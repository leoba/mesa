<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:redirect="org.apache.xalan.xslt.extensions.Redirect"
	extension-element-prefixes="redirect tei"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:collex="http://www.collex.org/schema#"
	xmlns:parker="http://parkerweb.stanford.edu/schema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:tei="http://www.tei-c.org/ns/1.0">

	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:strip-space elements="*"/>


	<!-- variables -->
	<xsl:variable name="baseURL">http://parkerweb.stanford.edu/parker/</xsl:variable>

	<xsl:variable name="newline">
		<xsl:text>
      
    </xsl:text>
	</xsl:variable>

	<xsl:param name="outputDir">RDF-Parker</xsl:param>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:TEI/tei:text/tei:body">
		<!--<xsl:choose>
			<xsl:when test="element-available('redirect:write')">-->
		<xsl:for-each select="tei:msDesc">
			<xsl:variable name="ms-id">
				<xsl:value-of select="tei:msIdentifier/tei:idno"/>
			</xsl:variable>

			<xsl:for-each select="tei:msContents/tei:msItem">

				<xsl:variable name="item-id">
					<xsl:value-of select="@n"/>
				</xsl:variable>

				<xsl:variable name="locus-start">
					<xsl:value-of select="@locusStart"/>
					<!-- e.g. 001_R -->
				</xsl:variable>
				

				<xsl:variable name="filename" select="concat($ms-id,'-',$item-id)"/>
				<xsl:result-document href="{$outputDir}/{$filename}.rdf">
					<xsl:value-of select="$newline"/>
					<rdf:RDF>
						<xsl:value-of select="$newline"/>
						<parker:pkr rdf:about="{$baseURL}uri/{$ms-id}-{$item-id}">
							<xsl:value-of select="$newline"/>
							<xsl:apply-templates select="."/>
							<xsl:value-of select="$newline"/>
							<xsl:comment>MESA specific metadata</xsl:comment>
							<xsl:value-of select="$newline"/>
							<collex:federation>MESA</collex:federation>
							<collex:archive>parker</collex:archive>
							<xsl:value-of select="$newline"/>
							<!-- Use this when we get permission to use the thumbnail images -->
							<!--<xsl:choose>
								<xsl:when test="matches($ms-id,'\d\d\d')">
									<collex:thumbnail
										rdf:resource="http://parkerweb.stanford.edu/parker/web/images/home_parkerLogo.png"
									/>
								</xsl:when>
								<xsl:when test="matches($ms-id,'\d\d')">
									<collex:thumbnail
										rdf:resource="{$baseURL}web/images/page_view/thumbnails/{$ms-id}/0{$ms-id}_{$locus-start}.jpg"
									/>
								</xsl:when>
								<xsl:when test="matches($ms-id,'\d')">
									<collex:thumbnail
										rdf:resource="{$baseURL}web/images/page_view/thumbnails/{$ms-id}/00{$ms-id}_{$locus-start}.jpg"
									/>
								</xsl:when>
							</xsl:choose>-->
							<collex:thumbnail
								rdf:resource="http://parkerweb.stanford.edu/parker/web/images/home_parkerLogo.png"/>



							<xsl:value-of select="$newline"/>
							<xsl:comment>Link that MESA should send users for this object</xsl:comment>
							<xsl:value-of select="$newline"/>

							<collex:text>
								<xsl:value-of select="tei:rubric"/>
								<xsl:value-of select="$newline"/>
								<xsl:value-of select="tei:incipit"/>
								<xsl:value-of select="$newline"/>
								<xsl:value-of select="tei:explicit"/>
							</collex:text>
							<rdfs:seeAlso
								rdf:resource="{$baseURL}actions/page_turner.do?ms_no={$ms-id}&amp;page={$locus-start}"/>
							<xsl:value-of select="$newline"/>
							<dcterms:isPartOf rdf:resource="{$baseURL}uri/{$ms-id}"/>
							<!--<xsl:call-template name="hasParts"/>-->
							<xsl:value-of select="$newline"/>
						</parker:pkr>
						<xsl:value-of select="$newline"/>
					</rdf:RDF>
				</xsl:result-document>
			</xsl:for-each>
		</xsl:for-each>
		<!--</xsl:when>
		</xsl:choose>-->
	</xsl:template>

	<xsl:template match="tei:msItem">
		<xsl:comment>Standard DublinCore metadata</xsl:comment>
		<xsl:value-of select="$newline"/>

		<!-- title -->
		<xsl:choose>
			<xsl:when test="tei:head[@type='CCC'] [position() = 1]">
				<dc:title>
					<xsl:choose><xsl:when test="tei:title">
					<xsl:value-of select="tei:head[@type='CCC']/tei:title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="tei:head[@type='CCC']"/>
					</xsl:otherwise>
					</xsl:choose>
				</dc:title>
			</xsl:when>
			<xsl:when test="tei:head[@type='James'] [position() = 1]">
				<dc:title>
					<xsl:value-of select="tei:head[@type='James']/tei:title"/>
				</dc:title>
			</xsl:when>
			<xsl:when test="tei:head[@type='Nasmith'] [position() = 1]">
				<dc:title>
					<xsl:value-of select="tei:head[@type='Nasmith']/tei:title"/>
				</dc:title>
			</xsl:when>
		</xsl:choose>

		<!-- author -->
		<xsl:choose>
			<xsl:when test="tei:head[@type='CCC'] [position() = 1]/tei:name">
				<role:AUT>
					<xsl:value-of select="tei:head[@type='CCC']/tei:name"/>
				</role:AUT>
			</xsl:when>
			<xsl:when test="tei:head[@type='James'] [position() = 1]/tei:name">
				<role:AUT>
					<xsl:value-of select="tei:head[@type='James']/tei:name"/>
				</role:AUT>
			</xsl:when>
			<xsl:when test="tei:head[@type='Nasmith'] [position() = 1]/tei:name">
				<role:AUT>
					<xsl:value-of select="tei:head[@type='Nasmith']/tei:name"/>
				</role:AUT>
			</xsl:when>
		</xsl:choose>

		<!-- publisher -->
		<role:PBL>
			<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:settlement"/>,
				<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:institution"/>,
				<xsl:value-of select="ancestor::tei:msDesc/tei:msIdentifier/tei:repository"/>
		</role:PBL>

		<collex:discipline>Manuscript Studies</collex:discipline>
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
		<xsl:for-each select=".">
			<xsl:if test="contains(., 'history')">
				<collex:discipline>History</collex:discipline>
			</xsl:if>
		</xsl:for-each>

		<dc:type>Manuscript</dc:type>
		<!-- I expect this will always be Codex? -->
		<dc:language>
			<xsl:value-of select="ancestor::tei:msContents/tei:textLang/@mainLang"/>
			<!--<xsl:value-of select="tei:msContents/tei:textLang/@mainLang"/>-->
		</dc:language>
		<xsl:if test="ancestor::tei:msContents/tei:textLang/@otherLangs">
			<xsl:for-each select="tokenize(ancestor::tei:msContents/tei:textLang/@otherLangs,' ')">
				<dc:language>
					<xsl:value-of select="."/>
				</dc:language>
			</xsl:for-each>
		</xsl:if>




		<!--date -->
		<xsl:choose>
			<xsl:when test="ancestor::tei:msDesc/tei:p[@function='Codicology']//tei:origDate">
				<xsl:for-each
					select="ancestor::tei:msDesc/tei:p[@function='Codicology']//tei:origDate">
					<dc:date>
						<collex:date>
							<xsl:choose>
								<xsl:when test=". = 'vi'">
									<rdfs:label>6th century</rdfs:label>
									<rdf:value>5uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'vii'">
									<rdfs:label>7th century</rdfs:label>
									<rdf:value>6uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'viii'">
									<rdfs:label>8th century</rdfs:label>
									<rdf:value>7uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'viii ?'">
									<rdfs:label>8th century?</rdfs:label>
									<rdf:value>7uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix'">
									<rdfs:label>9th century</rdfs:label>
									<rdf:value>8uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix-x'">
									<rdfs:label>9th century-10th century</rdfs:label>
									<rdf:value>0800,0900</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix late'">
									<rdfs:label>late 9th century</rdfs:label>
									<rdf:value>0880,0899</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix?'">
									<rdfs:label>9th century?</rdfs:label>
									<rdf:value>8uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'x (952)'">
									<rdfs:label>952</rdfs:label>
									<rdf:value>0952</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'x'">
									<rdfs:label>10th century</rdfs:label>
									<rdf:value>9uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'x early'">
									<rdfs:label>early 10th century</rdfs:label>
									<rdf:value>0900,0920</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'x ?'">
									<rdfs:label>10th century?</rdfs:label>
									<rdf:value>9uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'x(?)'">
									<rdfs:label>10th century?</rdfs:label>
									<rdf:value>9uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi'">
									<rdfs:label>11th century</rdfs:label>
									<rdf:value>10uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi?'">
									<rdfs:label>11th century?</rdfs:label>
									<rdf:value>10uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi (1064?)'">
									<rdfs:label>1064?</rdfs:label>
									<rdf:value>1064</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi. med.,'">
									<rdfs:label>middle 11th century</rdfs:label>
									<rdf:value>1040,1060</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi early'">
									<rdfs:label>early 11th century</rdfs:label>
									<rdf:value>1000,1020</rdf:value>
								</xsl:when>
								<xsl:when test=". = '? xi early'">
									<rdfs:label>early 11th century?</rdfs:label>
									<rdf:value>1000,1020</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi late?'">
									<rdfs:label>late 11th century?</rdfs:label>
									<rdf:value>1080,1099</rdf:value>
								</xsl:when>
								<xsl:when test=". = '11th cent.'">
									<rdfs:label>11th century</rdfs:label>
									<rdf:value>10uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii'">
									<rdfs:label>12th century</rdfs:label>
									<rdf:value>11uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii late'">
									<rdfs:label>late 12th century</rdfs:label>
									<rdf:value>1180,1199</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii early'">
									<rdfs:label>early 12th century</rdfs:label>
									<rdf:value>1100,1120</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii (1114-25)'">
									<rdfs:label>1114-1125</rdfs:label>
									<rdf:value>1114,1125</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii (1125-30)'">
									<rdfs:label>1125-1130</rdfs:label>
									<rdf:value>1125,1130</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii'">
									<rdfs:label>13th century</rdfs:label>
									<rdf:value>12uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii early'">
									<rdfs:label>early 13th century</rdfs:label>
									<rdf:value>1200,1220</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii late'">
									<rdfs:label>late 13th century</rdfs:label>
									<rdf:value>1280,1299</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii (early)'">
									<rdfs:label>early 13th century</rdfs:label>
									<rdf:value>1200,1220</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii (second half)'">
									<rdfs:label>13th century (second half)</rdfs:label>
									<rdf:value>1250,1299</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii and xiv early'">
									<rdfs:label>13th century and early 14th century</rdfs:label>
									<rdf:value> 12uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii-xiv early'">
									<rdfs:label>13th century-early 14th century</rdfs:label>
									<rdf:value>1200,1320</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii-xvi'">
									<rdfs:label>13th century-16th century</rdfs:label>
									<rdf:value>1200,1599</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii and xiv'">
									<rdfs:label>13th century and 14th century</rdfs:label>
									<rdf:value> 12uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii late or xiv early'">
									<rdfs:label>late 13th century or early 14th century</rdfs:label>
									<rdf:value> 1280,1299 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii (cir. 1250?)'">
									<rdfs:label>1250?</rdfs:label>
									<rdf:value>1250</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii early?'">
									<rdfs:label>early 13th century?</rdfs:label>
									<rdf:value>1200,1220</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii?'">
									<rdfs:label>13th century?</rdfs:label>
									<rdf:value>12uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv'">
									<rdfs:label>14th century</rdfs:label>
									<rdf:value>13uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = ' xiv'">
									<rdfs:label>14th century</rdfs:label>
									<rdf:value>13uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv early'">
									<rdfs:label>early 14th century</rdfs:label>
									<rdf:value>1300,1320</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (early)'">
									<rdfs:label>early 14th century</rdfs:label>
									<rdf:value>1300,1320</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (late)'">
									<rdfs:label>late 14th century</rdfs:label>
									<rdf:value>1380,1399</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv late'">
									<rdfs:label>late 14th century</rdfs:label>
									<rdf:value>1380,1399</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv late?'">
									<rdfs:label>late 14th century?</rdfs:label>
									<rdf:value>1380,1399</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (first half)'">
									<rdfs:label>14th century (first half)</rdfs:label>
									<rdf:value>1300,1350</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (1396 or 1397)'">
									<rdfs:label>1396 or 1397</rdfs:label>
									<rdf:value> 1396 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (1354)'">
									<rdfs:label>1354</rdfs:label>
									<rdf:value>1354</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (1398)'">
									<rdfs:label>1398</rdfs:label>
									<rdf:value>1398</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (1398, etc.)'">
									<rdfs:label>1398</rdfs:label>
									<rdf:value>1398</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (1376, etc.)'">
									<rdfs:label>1376</rdfs:label>
									<rdf:value>1376</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv 1378'">
									<rdfs:label>1378</rdfs:label>
									<rdf:value>1378</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (near 1300)'">
									<rdfs:label>1300?</rdfs:label>
									<rdf:value>1300</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (and xiii?)'">
									<rdfs:label>14th century and 13th century?</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'late 14th cent.'">
									<rdfs:label>late 14th century</rdfs:label>
									<rdf:value>1380,1399</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv late or xv early'">
									<rdfs:label>late 14th century or early 15th century</rdfs:label>

									<rdf:value> 1380,1399 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv late, or xv early'">
									<rdfs:label>late 14th century or early 15th century</rdfs:label>

									<rdf:value> 1380,1399 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv and xv late'">
									<rdfs:label>14th century and late 15th century</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv'">
									<rdfs:label>15th century</rdfs:label>
									<rdf:value>14uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv early?'">
									<rdfs:label>early 15th century?</rdfs:label>
									<rdf:value>1400,1420</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'cent. xv'">
									<rdfs:label>15th century</rdfs:label>
									<rdf:value>14uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvth cent.'">
									<rdfs:label>15th century</rdfs:label>
									<rdf:value>14uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv early'">
									<rdfs:label>early 15th century</rdfs:label>
									<rdf:value>1400,1420</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv (early)'">
									<rdfs:label>early 15th century</rdfs:label>
									<rdf:value>1400,1420</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv late'">
									<rdfs:label>late 15th century</rdfs:label>
									<rdf:value>1480,1499</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv late?'">
									<rdfs:label>late 15th century?</rdfs:label>
									<rdf:value>1480,1499</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv early (1403)'">
									<rdfs:label>1403</rdfs:label>
									<rdf:value>1403</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv (1432)'">
									<rdfs:label>1432</rdfs:label>
									<rdf:value>1432</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv (1431), etc.'">
									<rdfs:label>1431</rdfs:label>
									<rdf:value>1431</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv (1465)'">
									<rdfs:label>1465</rdfs:label>
									<rdf:value>1465</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv (1467)'">
									<rdfs:label>1467</rdfs:label>
									<rdf:value>1467</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv (1468)'">
									<rdfs:label>1468</rdfs:label>
									<rdf:value>1468</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv, rather late'">
									<rdfs:label>late 15th century</rdfs:label>
									<rdf:value>1480,1499</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv late (or xvi early)'">
									<rdfs:label>late 15th century or early 16th century</rdfs:label>
									<rdf:value> 1480,1499 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv late or xvi early'">
									<rdfs:label>late 15th century or early 16th century</rdfs:label>
									<rdf:value> 1480,1499 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv (about 1442)'">
									<rdfs:label>1442?</rdfs:label>
									<rdf:value>1442</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv, circ. 1470?'">
									<rdfs:label>1470?</rdfs:label>
									<rdf:value>1470</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv, second half'">
									<rdfs:label>15th century (second half)</rdfs:label>
									<rdf:value>1450,1499</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv late? or vi early'">
									<rdfs:label>late 15th century? or early 16th
										century</rdfs:label>
									<rdf:value> 1480,1499 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'third quarter of the fifteenth century'">
									<rdfs:label>15th century (third quarter)</rdfs:label>
									<rdf:value>1475,1499</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi'">
									<rdfs:label>16th century</rdfs:label>
									<rdf:value>15uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi (1525)'">
									<rdfs:label>1525</rdfs:label>
									<rdf:value>1525</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi (1550)'">
									<rdfs:label>1550</rdfs:label>
									<rdf:value>1550</rdf:value>
								</xsl:when>
								<xsl:when test="contains(.,'xvi') and contains(.,'1569')">
									<rdfs:label>1569</rdfs:label>
									<rdf:value>1569</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi early'">
									<rdfs:label>early 16th century</rdfs:label>
									<rdf:value>1500,1520</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi (first half)'">
									<rdfs:label>16th century (first half)</rdfs:label>
									<rdf:value>1500,1550</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi, 1st half'">
									<rdfs:label>16th century (first half)</rdfs:label>
									<rdf:value>1500,1550</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'Late sixteenth century'">
									<rdfs:label>late 16th century</rdfs:label>
									<rdf:value>1580,1599</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi (cir. 1567)'">
									<rdfs:label>1567?</rdfs:label>
									<rdf:value>1567</rdf:value>
								</xsl:when>
								<xsl:when test=". = '1570-74'">
									<rdfs:label>1570-1574</rdfs:label>
									<rdf:value>1570,1574</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvii'">
									<rdfs:label>17th century</rdfs:label>
									<rdf:value>16uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvii (?)'">
									<rdfs:label>17th century?</rdfs:label>
									<rdf:value>16uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = '17th cent. early'">
									<rdfs:label>early 17th century</rdfs:label>
									<rdf:value>1600,1620</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvii (1606)'">
									<rdfs:label>1606</rdfs:label>
									<rdf:value>1606</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvii (1623?)'">
									<rdfs:label>1623?</rdfs:label>
									<rdf:value>1623</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xviii'">
									<rdfs:label>18th century</rdfs:label>
									<rdf:value>17uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xviii early'">
									<rdfs:label>early 18th century</rdfs:label>
									<rdf:value>1700,1720</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'viii-ix'">
									<rdfs:label>8th century-9th century</rdfs:label>
									<rdf:value>0700,0899</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'x-xi, xii'">
									<rdfs:label>10th century-11th century, 12th century</rdfs:label>
									<rdf:value>0900,1099</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix-xi'">
									<rdfs:label>9th century-11th century</rdfs:label>
									<rdf:value>0800,1099</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'x-xi'">
									<rdfs:label>10th century-11th century</rdfs:label>
									<rdf:value>0900-1099</rdf:value>
								</xsl:when>
								<xsl:when
									test="contains(.,'xii late, xiii') and contains(.,'early')">
									<rdfs:label>late 12th century, early 13th century</rdfs:label>
									<rdf:value> 1180,1199 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv, xiii, xv'">
									<rdfs:label>14th century, 13th century, 15th
										century</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi-xii'">
									<rdfs:label>11th century-12th century</rdfs:label>
									<rdf:value>1000,1199</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi-xvi'">
									<rdfs:label>11th century-16th century</rdfs:label>
									<rdf:value>1000,1599</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii-xiii'">
									<rdfs:label>12th century-13th century</rdfs:label>
									<rdf:value>1100,1299</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii-xiii early'">
									<rdfs:label>12th century-early 13th century</rdfs:label>
									<rdf:value>1100,1220</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii-xiv'">
									<rdfs:label>12th century-14th century</rdfs:label>
									<rdf:value>1100,1399</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii-xiv'">
									<rdfs:label>13th century-14th century</rdfs:label>
									<rdf:value>1200,1399</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii -xiv'">
									<rdfs:label>13th century-14th century</rdfs:label>
									<rdf:value>1200,1399</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv-xv'">
									<rdfs:label>14th century-15th century</rdfs:label>
									<rdf:value>1300,1499</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv-xvi'">
									<rdfs:label>15th century-16th century</rdfs:label>
									<rdf:value>1400,1599</rdf:value>
								</xsl:when>
								<xsl:when test=". = '16-17th cent.'">
									<rdfs:label>16th century-17th century</rdfs:label>
									<rdf:value>1500,1699</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii late and xiii'">
									<rdfs:label>late 12th century and 13th century</rdfs:label>
									<rdf:value> 1180,1199 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii late and xiii early'">
									<rdfs:label>late 12th century and early 13th
										century</rdfs:label>
									<rdf:value> 1180,1199 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii and xiv'">
									<rdfs:label>12th century and 14th century</rdfs:label>
									<rdf:value> 11uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii and xv'">
									<rdfs:label>12th century and 15th century</rdfs:label>
									<rdf:value> 11uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii late or xiii early'">
									<rdfs:label>late 12th century or early 13th century</rdfs:label>
									<rdf:value> 1180,1199 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv and xii'">
									<rdfs:label>15th century and 12th century</rdfs:label>
									<rdf:value>14uu</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv and xiv'">
									<rdfs:label>15th century and 14th century</rdfs:label>
									<rdf:value> 14uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv and xvi'">
									<rdfs:label>15th century and 16th century</rdfs:label>
									<rdf:value> 14uu </rdf:value>
								</xsl:when>
								<xsl:when test="contains(.,'xiv and') and contains(.,'xii')">
									<rdfs:label>14th century and 12th century</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (and xv)'">
									<rdfs:label>14th century and 15th century</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi and xv'">
									<rdfs:label>16th century and 15th century</rdfs:label>
									<rdf:value> 15uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix-x and x-xi'">
									<rdfs:label>9th century-10th century, and 10th
										century-11th-century</rdfs:label>
									<rdf:value> 0800,999 </rdf:value>
								</xsl:when>
								<xsl:when test="contains(.,'xii late, xiii and xiv')">
									<rdfs:label>late 12th century, 13th century, and early 14th
										century</rdfs:label>
									<rdf:value> 1180,1199 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii early and xiv'">
									<rdfs:label>early 13th century and 14th century</rdfs:label>
									<rdf:value> 1200,1220 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii (xiii?) and xiv'">
									<rdfs:label>12th century (13th century?) and 14th
										century</rdfs:label>
									<rdf:value> 11uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii and xiii'">
									<rdfs:label>12th century and 13th century</rdfs:label>
									<rdf:value> 11uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv, xv'">
									<rdfs:label>14th century, 15th century</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test="contains(.,'1424') and contains(.,'1388')">
									<rdfs:label>1424 and 1388</rdfs:label>
									<rdf:value> 1424 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv? and xiii'">
									<rdfs:label>14th century? and 13th century</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv and xiii'">
									<rdfs:label>15th century and 13th century</rdfs:label>
									<rdf:value> 14uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi (and xii?)'">
									<rdfs:label>11th century and 12th century?</rdfs:label>
									<rdf:value> 10uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix-x (or x)'">
									<rdfs:label>9th century-10th century (or 10th
										century)</rdfs:label>
									<rdf:value> 0800,999 </rdf:value>
								</xsl:when>
								<xsl:when test="contains(.,'xvi and xv') and contains(.,'early')">
									<rdfs:label>16th century and early 15th century</rdfs:label>
									<rdf:value> 15uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'ix and xiv'">
									<rdfs:label>9th century and 14th century</rdfs:label>
									<rdf:value> 08uu </rdf:value>
								</xsl:when>
								<xsl:when test="contains(.,'xiii and xii') and contains(.,'late')">
									<rdfs:label>13th century and late 12th century</rdfs:label>
									<rdf:value> 12uu </rdf:value>
								</xsl:when>
								<xsl:when test="contains(.,'xi and xii') and contains(.,'early')">
									<rdfs:label>11th century and early 12th century</rdfs:label>
									<rdf:value> 10uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv-xvi early and xiv'">
									<rdfs:label>15th century-16th century and 14th
										century</rdfs:label>
									<rdf:value> 1400,1599 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv, xi-xii, xiv, xi'">
									<rdfs:label>15th century, 11th-12th century, 14th century, 11th
										century</rdfs:label>
									<rdf:value> 14uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi and xiii'">
									<rdfs:label>16th century and 13th century</rdfs:label>
									<rdf:value> 15uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xii-xiii, xvi and xiv'">
									<rdfs:label>12th century-13th century, 16th century and 14th
										century</rdfs:label>
									<rdf:value> 1100,1299 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv and xv late'">
									<rdfs:label>15th century and late 15th century</rdfs:label>
									<rdf:value> 14uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii early and xv'">
									<rdfs:label>early 13th century and 15th century</rdfs:label>
									<rdf:value> 1200,1220 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv and xiv late'">
									<rdfs:label>15th century and late 14th century</rdfs:label>
									<rdf:value> 14uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiv (and xvi)'">
									<rdfs:label>14th century and 16th century</rdfs:label>
									<rdf:value> 13uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xiii-xv'">
									<rdfs:label>13th century-15th century</rdfs:label>
									<rdf:value>1200,1499</rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv and xii-xiii'">
									<rdfs:label>15th century and 12th-13th century</rdfs:label>
									<rdf:value> 14uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xi (and xvi)'">
									<rdfs:label>11th century and 16th century</rdfs:label>
									<rdf:value> 10uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv late? or xvi early'">
									<rdfs:label>late 15th century? or early 16th
										century</rdfs:label>
									<rdf:value> 1480,1499 </rdf:value>
								</xsl:when>
								<xsl:when test=". = '?x and xi'">
									<rdfs:label>10th century? and 11th century</rdfs:label>
									<rdf:value> 09uu </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xv late and xvi early'">
									<rdfs:label>late 15th century and early 16th
										century</rdfs:label>
									<rdf:value> 1480,1499 </rdf:value>
								</xsl:when>
								<xsl:when test=". = 'xvi, xv, xii?, xiii'">
									<rdfs:label>16th century, 15th century, 12th century?, 13th
										century</rdfs:label>
									<rdf:value> 15uu </rdf:value>
								</xsl:when>
								<xsl:otherwise>
									<rdfs:label>
										<xsl:value-of select="."/>
									</rdfs:label>
									<rdf:value><xsl:value-of select="."/></rdf:value>
								</xsl:otherwise>
							</xsl:choose>
						</collex:date>
					</dc:date>
					<xsl:if test=". = 'xiii and xiv early'">

						<dc:date> 1300,1320 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiii and xiv'">

						<dc:date> 13uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiii late or xiv early'">

						<dc:date> 1300,1320 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv (1396 or 1397)'">

						<dc:date> 1397 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv (and xiii?)'">
						<dc:date> 12uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv late or xv early'">
						<dc:date> 1400,1420 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv late, or xv early'">
						<dc:date> 1400,1420 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv and xv late'">
						<dc:date> 1480,1499 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv late (or xvi early)'">

						<dc:date> 1500,1520 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv late or xvi early'">

						<dc:date> 1500,1520 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv late? or vi early'">

						<dc:date> 1500,1520 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'x-xi, xii'">
						<dc:date> 0900,1099 </dc:date>
						<dc:date> 11uu </dc:date>
					</xsl:if>
					<xsl:if test="contains(.,'xii late, xiii') and contains(.,'early')">

						<dc:date> 1200,1220 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv, xiii, xv'">

						<dc:date> 12uu </dc:date>
						<dc:date> 14uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii late and xiii'">

						<dc:date> 12uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii late and xiii early'">

						<dc:date> 1200,1220 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii and xiv'">

						<dc:date> 13uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii and xv'">

						<dc:date> 14uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii late or xiii early'">
						<dc:date> 1180,1199 </dc:date>
						<dc:date> 1200,1220 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv and xii'">
						<dc:date> 11uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv and xiv'">

						<dc:date> 13uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv and xvi'">

						<dc:date> 15uu </dc:date>
					</xsl:if>
					<xsl:if test="contains(.,'xiv and') and contains(.,'xii')">

						<dc:date> 11uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv (and xv)'">

						<dc:date> 14uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xvi and xv'">

						<dc:date> 14uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'ix-x and x-xi'">

						<dc:date> 0900,1099 </dc:date>
					</xsl:if>
					<xsl:if test="contains(.,'xii late, xiii and xiv')">

						<dc:date> 12uu </dc:date>
						<dc:date> 1300,1320 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiii early and xiv'">

						<dc:date> 13uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii (xiii?) and xiv'">

						<dc:date> 12uu </dc:date>
						<dc:date> 13uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii and xiii'">

						<dc:date> 12uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv, xv'">

						<dc:date> 14uu </dc:date>
					</xsl:if>
					<xsl:if test="contains(.,'1424') and contains(.,'1388')">

						<dc:date> 1388 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv? and xiii'">

						<dc:date> 12uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv and xiii'">

						<dc:date> 12uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xi (and xii?)'">

						<dc:date> 11uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'ix-x (or x)'">

						<dc:date> 09uu </dc:date>
					</xsl:if>
					<xsl:if test="contains(.,'xvi and xv') and contains(.,'early')">

						<dc:date> 1400,1420 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'ix and xiv'">

						<dc:date> 13uu </dc:date>
					</xsl:if>
					<xsl:if test="contains(.,'xiii and xii') and contains(.,'late')">

						<dc:date> 1180,1199 </dc:date>
					</xsl:if>
					<xsl:if test="contains(.,'xi and xii') and contains(.,'early')">

						<dc:date> 1100,1120 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv-xvi early and xiv'">

						<dc:date> 13uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv, xi-xii, xiv, xi'">

						<dc:date> 1000,1199 </dc:date>
						<dc:date> 13uu </dc:date>
						<dc:date> 10uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xvi and xiii'">

						<dc:date> 12uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xii-xiii, xvi and xiv'">

						<dc:date> 15uu </dc:date>
						<dc:date> 13uu </dc:date>
					</xsl:if>

					<xsl:if test=". = 'xiii early and xv'">

						<dc:date> 14uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv and xiv late'">

						<dc:date> 1380-1399 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xiv (and xvi)'">

						<dc:date> 15uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv and xii-xiii'">

						<dc:date> 1100,1299 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xi (and xvi)'">

						<dc:date> 15uu </dc:date>
					</xsl:if>

					<xsl:if test=". = 'xv late? or xvi early'">

						<dc:date> 1500,1520 </dc:date>
					</xsl:if>
					<xsl:if test=". = '?x and xi'">

						<dc:date> 10uu </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xv late and xvi early'">

						<dc:date> 1500,1520 </dc:date>
					</xsl:if>
					<xsl:if test=". = 'xvi, xv, xii?, xiii'">

						<dc:date> 14uu </dc:date>
						<dc:date> 11uu </dc:date>
						<dc:date> 12uu </dc:date>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<dc:date> Unknown </dc:date>
			</xsl:otherwise>
		</xsl:choose>



		<xsl:value-of select="$newline"/>

		<!--freeculture-->
		<collex:freeculture>false</collex:freeculture>
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
