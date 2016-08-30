<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="oai marc">
    <xsl:strip-space elements="*"/>
    <xsl:variable name="DocLookup" select="document('HathiTitleGovLookUp2014.xml')"/>
    <xsl:key name="title-lookup" match="DocValue" use="@code"/>
    <!--xsl:key name="gov-lookup" match="DocValue" use="@code"/-->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/*">
        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
            <xsl:copy-of select="oai:responseDate"/>
            <xsl:copy-of select="oai:request"/>
            <xsl:apply-templates select="oai:ListRecords"/>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="oai:ListRecords">
        <xsl:element name="ListRecords">
            <xsl:for-each select="oai:record">
                <xsl:variable name="varIdentifier">
                    <xsl:value-of select="substring-after(oai:header/oai:identifier,'edu:')"/>
                </xsl:variable>
                <xsl:variable name="varTitle">
                    <xsl:for-each select="$DocLookup">
                        <xsl:value-of select="key('title-lookup',$varIdentifier)/text()"/>
                    </xsl:for-each>
                </xsl:variable>      
                <xsl:variable name="varGov">
                    <xsl:for-each select="$DocLookup">
                        <xsl:value-of select="key('title-lookup',$varIdentifier)"/>
                    </xsl:for-each>
                </xsl:variable> 
                <xsl:choose>
                    <xsl:when test="oai:header[@status='deleted']">
                        <xsl:element name="record">
                            <xsl:copy-of select="oai:header"/>
                        </xsl:element>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="record">
                            <xsl:copy-of select="oai:header"/>
                            <xsl:element name="metadata">
                                <xsl:apply-templates select="oai:metadata">
                                    <xsl:with-param name="title">
                                        <xsl:value-of select="$varTitle"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="govdoc">
                                        <xsl:value-of select="$varGov"/>
                                    </xsl:with-param>
                                </xsl:apply-templates>
                            </xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="oai:metadata">
        <xsl:param name="title"/>
        <xsl:param name="paraGov"/>
        <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:for-each select="marc:record/*">
                <xsl:choose>
                    <xsl:when test="@tag='245'">
                        <xsl:element name="marc:datafield">
                            <xsl:attribute name="tag">245</xsl:attribute>
                            <xsl:attribute name="ind1"><xsl:value-of select="@ind1"/></xsl:attribute>
                            <xsl:attribute name="ind2"><xsl:value-of select="@ind2"/></xsl:attribute>
                            <xsl:element name="marc:subfield">
                                <xsl:attribute name="code">a</xsl:attribute><xsl:value-of select="$title"></xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        <xsl:if test="$paraGov = '1'">
                            <xsl:element name="marc:datafield">
                                <xsl:attribute name="tag">074</xsl:attribute>
                                <xsl:attribute name="ind1">
                                    <xsl:text> </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:text> </xsl:text>
                                </xsl:attribute>
                                <xsl:element name="marc:subfield">
                                    <xsl:attribute name="code">a</xsl:attribute>
                                    <xsl:text>HathiTrust Gov Doc</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                 </xsl:choose>
            </xsl:for-each>
        </marc:record>
        
    </xsl:template>
</xsl:stylesheet>