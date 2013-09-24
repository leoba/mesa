<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:redirect="org.apache.xalan.xslt.extensions.Redirect"
	extension-element-prefixes="redirect tei"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:collex="http://www.collex.org/schema#"
	xmlns:courtauld="http://www.gothicivories.courtauld.ac.uk/images/ivory/schema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:oai="http://www.openarchives.org/OAI/2.0/"
	xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
	xmlns:xls="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel"
	xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:html="http://www.w3.org/TR/REC-html40">

	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:strip-space elements="*"/>


	<!-- variables -->
	<xsl:variable name="baseURL"
		>http://www.gothicivories.courtauld.ac.uk/images/ivory/</xsl:variable>

	<xsl:variable name="newline">
		<xsl:text>
      
    </xsl:text>
	</xsl:variable>

	<xsl:param name="outputDir">RDF-Courtauld</xsl:param>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="xls:Workbook/xls:Worksheet/xls:Table">
		<!--<xsl:choose>
			<xsl:when test="element-available('redirect:write')">-->
		<xsl:for-each select="xls:Row">
			<xsl:variable name="ID">
				<xsl:value-of select="xls:Cell[1]/xls:Data"/>
			</xsl:variable>
			<!-- Not using cell 2 - repeat of cell 8 -->
			<xsl:variable name="Part">
				<xsl:value-of select="xls:Cell[3]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Subject1">
				<xsl:value-of select="xls:Cell[4]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="dateLabel">
				<xsl:value-of select="xls:Cell[5]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="dateValue1">
				<xsl:value-of select="xls:Cell[6]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="dateValue2">
				<xsl:value-of select="xls:Cell[7]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Fulltext1">
				<xsl:value-of select="xls:Cell[8]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Subject2">
				<xsl:value-of select="xls:Cell[9]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Repository">
				<xsl:value-of select="xls:Cell[10]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Fulltext2">
				<xsl:value-of select="xls:Cell[11]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Provenance1">
				<xsl:value-of select="xls:Cell[12]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Fulltext3">
				<xsl:value-of select="xls:Cell[13]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Provenance2">
				<xsl:value-of select="xls:Cell[14]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Discipline">
				<xsl:value-of select="xls:Cell[15]/xls:Data"/>
			</xsl:variable>
			<xsl:variable name="Title">
				<xsl:value-of select="xls:Cell[16]/xls:Data"/>
			</xsl:variable>

			<xsl:variable name="firstPartOfURL">
				<xsl:value-of select="substring($ID,1,8)"/>
			</xsl:variable>
			<xsl:variable name="secondPartOfID">
				<xsl:value-of select="tokenize($ID,'_') [position() = 2]"/>
			</xsl:variable>
			<xsl:variable name="secondPartOfURL">
				<xsl:value-of select="substring($secondPartOfID,1,8)"/>
			</xsl:variable>


			<xsl:variable name="filename" select="concat($firstPartOfURL,'_',$secondPartOfURL)"/>
			<xsl:result-document href="{$outputDir}/{$filename}.rdf">
				<xsl:value-of select="$newline"/>
				<rdf:RDF>
					<xsl:value-of select="$newline"/>
					<courtauld:ctd rdf:about="{$baseURL}URI/{$firstPartOfURL}_{$secondPartOfURL}">
						<xsl:value-of select="$newline"/>

						<xsl:comment>Standard DublinCore metadata</xsl:comment>
						<xsl:value-of select="$newline"/>

						<!-- title -->
						<dc:title>
							<xsl:value-of select="$Title"/>
						</dc:title>
						


						<!-- repository  -->
						<role:RPS>
							<xsl:choose>
								<xsl:when test="$Repository">
									<xsl:value-of select="$Repository"/>
								</xsl:when>
								<xsl:otherwise>Unknown</xsl:otherwise>
							</xsl:choose>
						</role:RPS>

						<xsl:for-each select="$Discipline">
							<collex:discipline>Art History</collex:discipline>
							<xsl:for-each select=".">
								<xsl:if test="contains(., 'music')">
									<collex:discipline>Musicology</collex:discipline>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select=".">
								<xsl:if test="contains(., 'religion')">
									<collex:discipline>Religious Studies</collex:discipline>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select=".">
								<xsl:if test="contains(., 'law')">
									<collex:discipline>Law</collex:discipline>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>

						<dc:type>Physical Object</dc:type>






						<!--date -->

						<xsl:variable name="startDate">
							<xsl:value-of select="tokenize($dateValue1,'/')  [position() = 3]"/>
						</xsl:variable>
						<xsl:variable name="endDate">
							<xsl:value-of select="tokenize($dateValue2,'/')  [position() = 3]"/>
						</xsl:variable>

						<dc:date>
							<collex:date>
								<rdfs:label>
									<xsl:value-of select="$dateLabel"/>
								</rdfs:label>
								<xsl:choose>
									<xsl:when test="$dateValue1 and $dateValue2">
										<rdf:value>
											<xsl:value-of select="$startDate"/>,<xsl:value-of
												select="$endDate"/>
										</rdf:value>
									</xsl:when>
									<xsl:when test="$dateValue1 = 0 and $dateValue2 = 0">
										<rdf:value>
											<xsl:value-of select="$dateLabel"/>
										</rdf:value>
									</xsl:when>
									<xsl:when test="$dateValue1 = 0">
										<rdf:value>
											<xsl:value-of select="$dateValue2"/>
										</rdf:value>
									</xsl:when>
									<xsl:when test="$dateValue2 = 0">
										<rdf:value>
											<xsl:value-of select="$dateValue1"/>
										</rdf:value>
									</xsl:when>
								</xsl:choose>
							</collex:date>
						</dc:date>

						<dc:provenance>
							<xsl:value-of select="$Provenance1"/>
						</dc:provenance>
						<dc:provenance>
							<xsl:value-of select="$Provenance2"/>
						</dc:provenance>



						<xsl:for-each select="tokenize($Subject1,';')">
							<dc:subject>
								<xsl:value-of select="."/>
							</dc:subject>
						</xsl:for-each>


						<xsl:value-of select="$newline"/>

						<!--freeculture-->
						<collex:freeculture>false</collex:freeculture>
						<xsl:value-of select="$newline"/>

						<!-- genre -->
						<collex:genre>Nonfiction</collex:genre>
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
								<collex:genre>Religion</collex:genre>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select=".">
							<xsl:if test="contains(., 'scripture')">
								<collex:genre>Religion</collex:genre>
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

						<xsl:value-of select="$newline"/>
						<xsl:comment>MESA specific metadata</xsl:comment>
						<xsl:value-of select="$newline"/>
						<collex:federation>MESA</collex:federation>
						<collex:archive>courtauld</collex:archive>
						<xsl:value-of select="$newline"/>
						<collex:thumbnail
							rdf:resource="http://www.gothicivories.courtauld.ac.uk/layout/title.gif"/>

						<collex:text>
							<xsl:value-of select="$Fulltext1"/>
							<xsl:value-of select="$newline"/>
							<xsl:value-of select="$Fulltext2"/>
							<xsl:value-of select="$newline"/>
							<xsl:value-of select="$Fulltext3"/>
							<xsl:value-of select="$newline"/>
						</collex:text>


						<xsl:comment>Link that MESA should send users for this object</xsl:comment>
						<xsl:value-of select="$newline"/>

						<rdfs:seeAlso
							rdf:resource="{$baseURL}{$firstPartOfURL}_{$secondPartOfURL}.html"/>
						<xsl:value-of select="$newline"/>
						<!--<xsl:call-template name="hasParts"/>-->
						<xsl:value-of select="$newline"/>
					</courtauld:ctd>
					<xsl:value-of select="$newline"/>
				</rdf:RDF>
			</xsl:result-document>
		</xsl:for-each>
		<!--</xsl:when>
		</xsl:choose>-->
	</xsl:template>



	<!--<xsl:template name="hasParts">
		<xsl:for-each select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='work']">
			<dcterms:hasPart>
				<xsl:attribute name="rdf:resource">
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:attribute>
			</dcterms:hasPart>
		</xsl:for-each>
	</xsl:template>-->

</xsl:stylesheet>
