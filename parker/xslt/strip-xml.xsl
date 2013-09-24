<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all">

    <xsl:output encoding="UTF-8" method="text" indent="yes"/>
    <xsl:param name="outputDir">ParkerText</xsl:param>

    <xsl:template match="tei:TEI/tei:text/tei:body">
        <xsl:for-each select="tei:msDesc">
            <xsl:variable name="id">
                <xsl:value-of
                    select="tei:msIdentifier/tei:idno"
                />
            </xsl:variable>
            <xsl:variable name="filename" select="$id"/>
            <xsl:result-document href="{$outputDir}/{$filename}.txt">
                <xsl:apply-templates/>
                <!--<xsl:call-template name="fileDesc"/>
            <xsl:call-template name="encodingDesc"/>
            <xsl:call-template name="profileDesc"/>-->
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>



    <!-- match anything not matched by another template  -->
    <xsl:template match="*" priority="-1">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

</xsl:stylesheet>
