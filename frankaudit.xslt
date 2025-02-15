<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:strip-space elements="*"/>
  <xsl:template match="/Object">
		<html>
			<body>
				<table style="width:60%">
          <tr>
            <th>Attribute</th>
            <th>Current Value</th>
						<th>New Value</th>
          </tr>
					<xsl:apply-templates>
						<xsl:sort select="@name" order="ascending"/>
					</xsl:apply-templates>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="Attribute[not(./Object) and not(../../..)]">
    <xsl:variable name="currentName" select="./@name"/>
      
		<xsl:choose>
			
			<!--<xsl:when test="../Attribute[@name='AttributeChangeOperation']/Object[@name='AttributeChangeOperation.operation.replace']/Attribute[@name=current()/@name]">-->
      <xsl:when test="../Attribute/Object[contains(@name,'.replace')]/Attribute[@name=$currentName]">				
          <tr style="background:yellow;">
          <xsl:message>
            <xsl:value-of select="concat($currentName,' ',current())"/>       
          </xsl:message>          
					<xsl:call-template name="tdtd"/>

					<td>
						<xsl:for-each select="../Attribute/Object/Attribute[@name=$currentName]/Scalar">
							<xsl:value-of select="normalize-space(.)"/>
							<br/>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:when>
			<!--<xsl:when test="../Attribute[@name='AttributeChangeOperation']/Object[@name='AttributeChangeOperation.operation.remove']/Attribute[@name=current()/@name]">-->
      <xsl:when test="../Attribute/Object[@name='AttributeChangeOperation.operation.remove']/Attribute[@name=$currentName]">
				<tr style="background:red;">
					<td>
						<xsl:value-of select="@name"/>
					</td>
					<td>
						<b>removed</b>
					</td>
					<td/>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<xsl:call-template name="tdtd"/>
					<td/>
				</tr>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>
  
	<xsl:template name="tdtd">
		<td>
			<xsl:value-of select="@name"/>
		</td>
		<xsl:call-template name="multiscalar"/>
	</xsl:template>

	<xsl:template name="multiscalar">
		<td>
			<xsl:for-each select="Scalar">
				<xsl:value-of select="substring(text(), 1, 20)"/>
				<xsl:if test="string-length(text()) &gt; 20">
					<xsl:text>...</xsl:text>
				</xsl:if>
				<br/>
			</xsl:for-each>
		</td>
	</xsl:template>
	

	<xsl:template name="removed" match="Attribute/Object[@name='AttributeChangeOperation.operation.remove']/Attribute">
		<tr/>
	</xsl:template>

	<xsl:template name="added" match="Attribute/Object[@name='AttributeChangeOperation.operation.add']/Attribute">
		<tr style="background:green;">
			<td>
				<xsl:value-of select="@name"/>
			</td>
			<td></td>
			<xsl:call-template name="multiscalar"/>
		</tr>
		<tr/>
	</xsl:template>

  <xsl:template match="Scalar"/>
</xsl:stylesheet>
