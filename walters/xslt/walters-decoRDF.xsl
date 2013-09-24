<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:redirect="org.apache.xalan.xslt.extensions.Redirect"
	extension-element-prefixes="redirect tei"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:collex="http://www.collex.org/schema#" xmlns:walters="http://thedigitalwalters.org/schema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:tei="http://www.tei-c.org/ns/1.0">

	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:strip-space elements="*"/>


	<!-- variables -->
	<xsl:variable name="baseURL">http://thedigitalwalters.org/Data/WaltersManuscripts</xsl:variable>

	<xsl:variable name="newline">
		<xsl:text>
      
    </xsl:text>
	</xsl:variable>

	<xsl:param name="outputDir">RDF-Walters</xsl:param>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	

	<xsl:variable name="sigla">
		<xsl:value-of
			select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno"
		/>
	</xsl:variable>

	<xsl:variable name="ms-id">
		<xsl:value-of select="translate($sigla,'.','')"/>
	</xsl:variable>
	


	<xsl:template match="tei:TEI">
		<!--<xsl:choose>
			<xsl:when test="element-available('redirect:write')">-->
		<xsl:for-each
			select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:decoDesc/tei:decoNote[contains(@n,'fol.')]">
			<!--<xsl:variable name="id">
					<xsl:value-of select="translate(tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno, '.', '')"/>
					</xsl:variable>-->
			<xsl:variable name="itemID">
				<xsl:value-of select="@xml:id"/>
			</xsl:variable>
			<xsl:variable name="filename">
				<xsl:value-of select="$ms-id"/>-<xsl:value-of select="$itemID"/>
			</xsl:variable>
			<xsl:variable name="folio">
				<xsl:value-of select="@n"/>
			</xsl:variable>
			
			<xsl:variable name="thumbnail">
				<xsl:value-of select="//tei:surface[@n=concat($folio, '')]/tei:graphic[position() = 4]/@url"/>
			</xsl:variable>
			
			<xsl:variable name="full-size">
				<xsl:value-of select="//tei:surface[@n=concat($folio, '')]/tei:graphic[position() = 3]/@url"/>
			</xsl:variable>
			<xsl:result-document href="{$outputDir}/deco-{$filename}.rdf">
				<xsl:value-of select="$newline"/>
				<rdf:RDF>
					<xsl:value-of select="$newline"/>
					<walters:wam rdf:about="{$baseURL}/ManuscriptDescriptions/{$ms-id}/{$itemID}">
						<xsl:value-of select="$newline"/>
						
						<xsl:call-template name="decoNote"/>
						
						<xsl:value-of select="$newline"/>
						<xsl:comment>MESA specific metadata</xsl:comment>
						<xsl:value-of select="$newline"/>
						
						<xsl:variable name="notBefore"><xsl:value-of select="number(ancestor::tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notBefore)"/></xsl:variable>
						<xsl:variable name="when"><xsl:value-of select="number(ancestor::tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@when)"/></xsl:variable>
						<!--<xsl:choose>
							<xsl:when test="1550 > $when">
								<collex:federation>MESA</collex:federation>
							</xsl:when>
							<xsl:otherwise>
								<collex:federation>18thConnect</collex:federation>
							</xsl:otherwise>
						</xsl:choose>-->
						<xsl:choose>
							<xsl:when test="number(1600) > $when">
								<collex:federation>MESA</collex:federation>
							</xsl:when>
							<xsl:when test="number(1749) > $when">
								<collex:federation>18thConnect</collex:federation></xsl:when>
							<xsl:when test="number(1799) > $when">
								<collex:federation>18thConnect</collex:federation>
								<collex:federation>NINES</collex:federation>
							</xsl:when>
							<xsl:when test="number(1600) > $notBefore">
								<collex:federation>MESA</collex:federation>
							</xsl:when>
							<xsl:when test="number(1749) > $notBefore">
								<collex:federation>18thConnect</collex:federation></xsl:when>
							<xsl:when test="number(1799) > $notBefore">
								<collex:federation>18thConnect</collex:federation>
								<collex:federation>NINES</collex:federation>
							</xsl:when>
							<xsl:otherwise>
								<collex:federation>NINES</collex:federation>
							</xsl:otherwise>
						</xsl:choose>
						<collex:archive>walters</collex:archive>
						<xsl:value-of select="$newline"/>
						<collex:thumbnail
							rdf:resource="{$baseURL}/{$ms-id}/data/{$sigla}/{$thumbnail}"/>
						<collex:source_xml>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of
									select="concat($baseURL, '/ManuscriptDescriptions/', $ms-id, '_tei.xml')"
								/>
							</xsl:attribute>
						</collex:source_xml>
						<xsl:value-of select="$newline"/>
						<collex:text>
							<xsl:for-each select="tei:note">
								<xsl:value-of select="."/><xsl:value-of select="$newline"/>
							</xsl:for-each>
						</collex:text>
						<xsl:comment>Link that MESA should send users for this object</xsl:comment>
						<xsl:value-of select="$newline"/>
						<rdfs:seeAlso rdf:resource="{$baseURL}/{$ms-id}/data/{$sigla}/{$full-size}"/>
						<xsl:value-of select="$newline"/>
						<dcterms:isPartOf rdf:resource="{$baseURL}/ManuscriptDescriptions/{$ms-id}"/>
						<xsl:value-of select="$newline"/>
					</walters:wam>
					<xsl:value-of select="$newline"/>
				</rdf:RDF>
			</xsl:result-document>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="decoNote" match="tei:decoNote">
		<xsl:variable name="folio">
			<xsl:value-of select="@n"/>
		</xsl:variable>
		<xsl:comment>Standard DublinCore metadata</xsl:comment>
		<xsl:value-of select="$newline"/>

		<!-- title -->
		<dc:title>
				<xsl:value-of select="tei:title"/>, <xsl:value-of select="$sigla"/>, <xsl:value-of select="$folio"/>
		</dc:title>

		<!-- creator  -->



		<collex:discipline>Art History</collex:discipline>
		<collex:discipline>Manuscript Studies</collex:discipline>
		<dc:type>
			<xsl:choose>
				<xsl:when test="contains(/tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords, 'Codex')">
					Codex</xsl:when>
				<xsl:otherwise>Sheet</xsl:otherwise>
			</xsl:choose>
		</dc:type>
		<dc:type>Manuscript</dc:type>
		<dc:language>
			<xsl:value-of
				select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:textLang/@mainLang"
			/>
		</dc:language>

		<!-- publisher -->
		<role:PBL>
			<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher"/>
		</role:PBL>


		<!--date -->
		<dc:date>
			<xsl:choose>
				<xsl:when
					test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notBefore">
					<xsl:value-of
						select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notBefore"
					/>
				</xsl:when>
				<xsl:when
					test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notAfter">
					<xsl:value-of
						select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notAfter"
					/>
				</xsl:when>
				<xsl:when
					test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notBefore and tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notAfter">
					<xsl:value-of
						select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notBefore"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of
						select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@notAfter"
					/>
				</xsl:when>
				<xsl:when test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@when">
					<xsl:value-of
						select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/@when"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Uncertain</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</dc:date>
		<xsl:value-of select="$newline"/>

		<!--freeculture-->
		<collex:freeculture>true</collex:freeculture>
		<xsl:value-of select="$newline"/>

		<!-- genre -->
		<!--<xsl:variable name="length">
			<xsl:value-of select="string-length(tei:profileDesc/tei:textClass/tei:catRef[@scheme='#genres']/@target)"/>
		</xsl:variable>
		<xsl:variable name="end">
			<xsl:value-of select="$length - 2"/>
			</xsl:variable>-->

		<collex:genre>Nonfiction</collex:genre>
		
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'sermon')">
				<collex:genre>Sermon</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'music')">
				<collex:genre>Music, Other</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'stave')">
				<collex:genre>Musical Score</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'law')">
				<collex:genre>Law</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'poetry')">
				<collex:genre>Poetry</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'liturgy')">
				<collex:genre>Liturgy</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'scripture')">
				<collex:genre>Scripture</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'philosophy')">
				<collex:genre>Philosophy</collex:genre>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'religion')">
				<collex:genre>Religion</collex:genre>
			</xsl:if>
		</xsl:for-each>

		<xsl:for-each select="tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass/tei:catRef[@scheme='#genres']/@target">
			<xsl:choose>
				<xsl:when test=". = '#genre_1'">
					<collex:genre>Religion</collex:genre>
				</xsl:when>
				<xsl:when test=". = '#genre_2'">
					<collex:genre>Religion</collex:genre>
				</xsl:when>
				<xsl:when test=". = '#genre_3'">
					<collex:genre>Religion</collex:genre>
				</xsl:when>
				<xsl:when test=". = '#genre_4'">
					<collex:genre>Religion</collex:genre>
				</xsl:when>

				<xsl:when test=". = '#genre_5'">
					<collex:genre>Law</collex:genre>
				</xsl:when>

				<xsl:when test=". = '#genre_6'">
					<collex:genre>Nonfiction</collex:genre>
				</xsl:when>

				<xsl:when test=". = '#genre_7'">
					<collex:genre>Nonfiction</collex:genre>
				</xsl:when>

				<xsl:when test=". = '#genre_8'">
					<collex:genre>Nonfiction</collex:genre>
				</xsl:when>

				<xsl:when test=". = '#genre_10'">
					<collex:genre>Poetry</collex:genre>
				</xsl:when>
				<xsl:when test=". = '#genre_11'">
					<collex:genre>Philosophy</collex:genre>
				</xsl:when>
				<xsl:when test=". = '#genre_12'">
					<collex:genre>Philosophy</collex:genre>
				</xsl:when>
				<xsl:when test=". = '#genre_13'">
					<collex:genre>Religion</collex:genre>
				</xsl:when>
			</xsl:choose>
			
		</xsl:for-each>



	</xsl:template>

	<xsl:template name="isPartOf">
		<xsl:for-each select="//tei:msItem">
			<xsl:variable name="itemID">
				<xsl:value-of select="@xml:id"/>
			</xsl:variable>
			<dcterms:hasPart rdf:resource="{$baseURL}/ManuscriptDescriptions/{$ms-id}"/>

		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
