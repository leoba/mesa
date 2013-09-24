<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- RUN THIS FILE AGAINST tbexCollection.xml -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:collex="http://www.collex.org/schema#"
  xmlns:bl="http://www.bl.uk/catalogues/illuminatedmanuscripts/schema#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:role="http://www.loc.gov/loc.terms/relators/" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xls="urn:schemas-microsoft-com:office:spreadsheet"
  xmlns:od="urn:schemas-microsoft-com:officedata">
  <!--<xsl:param name="msid"/>-->
  <xsl:variable name="baseURL">http://www.bl.uk/catalogues/illuminatedmanuscripts/</xsl:variable>
  <xsl:variable name="newline">
    <xsl:text>
      
    </xsl:text>
  </xsl:variable>

  <xsl:param name="outputDir">RDF-BL</xsl:param>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dataroot">

    <xsl:for-each select="//tbexIllumination">

      <xsl:variable name="repository">British Library</xsl:variable>
      <xsl:variable name="datestart" select="ancestor::tbexMSParts/StartDate"/>
      <xsl:variable name="dateend" select="ancestor::tbexMSParts/EndDate"/>
      <xsl:variable name="date" select="ancestor::tbexMSParts/Dates"/>

      <xsl:variable name="MSID">
        <xsl:value-of select="ancestor::tbexMSParts/MSID"/>
      </xsl:variable>
      <xsl:variable name="CollID">
        <xsl:value-of select="ancestor::tbexMSDetails/CollID"/>
      </xsl:variable>
      <xsl:variable name="NStart">
        <xsl:value-of select="ancestor::tbexMSDetails/NStart"/>
      </xsl:variable>
      <xsl:variable name="IllID">
        <xsl:value-of select="IllID"/>
      </xsl:variable>
      <xsl:variable name="Collection">
        <xsl:value-of select="ancestor::tbexCollection/CollectionName"/>
      </xsl:variable>
      <xsl:variable name="SourceTitle">
        <xsl:value-of select="ancestor::tbexMSParts/Title"/>
      </xsl:variable>
      <xsl:variable name="Title">
        <xsl:value-of select="Description"/>
      </xsl:variable>
      <xsl:variable name="Provenance">
        <xsl:value-of select="ancestor::tbexMSDetails/Provenance"/>
      </xsl:variable>
      <xsl:variable name="Fulltext1">
        <xsl:value-of select="ancestor::tbexMSParts/Origin"/>
      </xsl:variable>
      <xsl:variable name="Fulltext2">
        <xsl:value-of select="ancestor::tbexMSParts/Illumination"/>
      </xsl:variable>
      <xsl:variable name="Fulltext3">
        <xsl:value-of select="ancestor::tbexMSParts/Script"/>
      </xsl:variable>
      <xsl:variable name="Fulltext4">
        <xsl:value-of select="ancestor::tbexMSDetails/Notes"/>
      </xsl:variable>
      <xsl:variable name="Form">
        <xsl:value-of select="ancestor::tbexMSDetails/Form"/>
      </xsl:variable>
      <xsl:variable name="Scribe">
        <xsl:value-of select="ancestor::tbexMSParts/Scribe"/>
      </xsl:variable>
      <xsl:variable name="PartID">
        <xsl:value-of select="ancestor::tbexMSParts/PartID"/>
      </xsl:variable>


      <xsl:variable name="websiteurl"><xsl:value-of select="$baseURL"
          />ILLUMIN.ASP?Size=mid&amp;IllID=<xsl:value-of select="$IllID"/></xsl:variable>

      <xsl:variable name="filename"><xsl:value-of select="$MSID"/>-<xsl:value-of select="$CollID"
          />-<xsl:value-of select="$PartID"/>-<xsl:value-of select="$IllID"/></xsl:variable>
      <xsl:result-document href="{$outputDir}/{$filename}.rdf">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
          xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
          xmlns:collex="http://www.collex.org/schema#"
          xmlns:bl="http://www.bl.uk/catalogues/illuminatedmanuscripts/schema#"
          xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
          xmlns:role="http://www.loc.gov/loc.terms/relators/"
          xmlns:tei="http://www.tei-c.org/ns/1.0">


          <bl:MSPart xmlns:bl="http://www.bl.uk/catalogues/illuminatedmanuscripts/mesa/ns/"
            rdf:about="{$baseURL}URI/{$filename}">

            <collex:federation>MESA</collex:federation>


            <collex:archive>BL</collex:archive>
            <xsl:choose>
              <xsl:when test="Description">
                <dc:title>
                  <xsl:value-of select="$Title"/>
                </dc:title>
              </xsl:when>
              <xsl:otherwise>
                <dc:title>
                  One of <xsl:value-of select="substring($Fulltext2,1,100)"/>...
                </dc:title>
              </xsl:otherwise>
            </xsl:choose>
            <dc:source>
              <xsl:value-of select="$repository"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$Collection"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$MSID"/>
            </dc:source>



            <role:RPS>
              <xsl:value-of select="$repository"/>
            </role:RPS>



            <collex:genre>Visual Art</collex:genre>
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


            <dc:type>Illustration</dc:type>
            <dc:type>Manuscript</dc:type>

            <xsl:for-each select=".">
              <collex:discipline>Manuscript Studies</collex:discipline>
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
              <xsl:for-each select=".">
                <xsl:if test="contains(., 'history')">
                  <collex:discipline>History</collex:discipline>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select=".">
                <xsl:if test="contains(., 'literature')">
                  <collex:discipline>Literature</collex:discipline>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select=".">
                <xsl:if test="contains(., 'philosophy')">
                  <collex:discipline>Philosophy</collex:discipline>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>

            <collex:freeculture>TRUE</collex:freeculture>
            <collex:ocr>FALSE</collex:ocr>
            <collex:fulltext>FALSE</collex:fulltext>

            <collex:text>
              <xsl:value-of select="$Fulltext1"/>
              <xsl:value-of select="$newline"/>
              <xsl:value-of select="$Fulltext2"/>
              <xsl:value-of select="$newline"/>
              <xsl:value-of select="$Fulltext3"/>
              <xsl:value-of select="$newline"/>
              <xsl:value-of select="$Fulltext4"/>
              <xsl:value-of select="$newline"/>
              <xsl:value-of select="$SourceTitle"/>
              <xsl:value-of select="$newline"/>
              <xsl:value-of select="$Scribe"/>
            </collex:text>


            <dc:date>
              <collex:date>
                <rdfs:label>
                  <xsl:value-of select="$date"/>
                </rdfs:label>
                <rdf:value><xsl:value-of select="$datestart"/>,<xsl:value-of select="$dateend"
                  /></rdf:value>
              </collex:date>
            </dc:date>
            <xsl:for-each select="ancestor::tbexMSParts/Language">
            <dc:language>
              <xsl:value-of select="."/>
            </dc:language></xsl:for-each>


            <collex:thumbnail
              rdf:resource="http://www.bl.uk/catalogues/illuminatedmanuscripts/images/logo.gif"/>

            <rdfs:seeAlso rdf:resource="{$websiteurl}"/>
          </bl:MSPart>

        </rdf:RDF>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
