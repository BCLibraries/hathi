<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
    xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:output method="text"/>
    <xsl:template match="/*">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="oai:ListRecords">
        <xsl:for-each select="oai:record">
            <xsl:choose>
                <xsl:when test="oai:header[@status='deleted']"/>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(oai:header/oai:identifier,'edu:')"/>
                    <xsl:text>
</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
