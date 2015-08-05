<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"  xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="yes" method="html"></xsl:output>
    <!-- Elena Koroleva, 29-06-2015 -->
    <!-- Transform a TEI P5 file in a JSON-LD manifest to be shown in Mirador viewer: Annotation lists -->
    
    <xsl:template match="/">		
        <xsl:for-each select="/TEI/facsimile//surface">
            <!-- On choisit l'xml:id de chaque élément 'surface' -->
            <xsl:variable name="surfaceID" select="@xml:id"/>
            <!-- On choisit la valeur de l'attribut 'n' de chaque élément 'pb' qui correspond à un élément 'surface' -->
            <xsl:variable name="pbNumber" select="/TEI/text/body//pb[@facs=concat('#',$surfaceID)]/@n"/>
            <!-- On crée les noms des futurs fichiers qui contiendront chacun la transcription d'une page (recto ou verso d'un folio)  -->
            <xsl:variable name="outputFile">transscript_<xsl:value-of select="$pbNumber"/>.json</xsl:variable>
            <!-- On choisit l'url de chaque image (=recto ou verso d'un folio) -->
            <xsl:variable name="graphicURL"><xsl:value-of select="/TEI/facsimile/surface/graphic/@url"/></xsl:variable>
            
            <!-- On crée les fichiers contenant la trancription -->
            <xsl:result-document href="{$outputFile}" method="text" encoding="UTF-8" indent="yes">
                
                {
                
                "@context": "http://iiif.io/api/presentation/2/context.json",
                "@id": "http://demos.biblissima-condorcet.fr/iiif/metadata/BnF_Latin2859_transcript/list/transscript_<xsl:value-of select="$pbNumber"/>.json",
                "@type": "sc:AnnotationList",
                "resources":[
                
                <xsl:for-each select="zone">
                    <!-- On choisit le numéro de la ligne qui correspond à la zone courante -->
                    <xsl:variable name="currentLineNumber" select="number(substring-after(@xml:id,'l'))"/>
                    <!-- On met une virgule entre les descriptions des lignes à partir de la deuxième ligne -->
                    <xsl:if test="position()!=1"> ,</xsl:if>
                    
                    <xsl:choose>
                        <!-- Si la ligne n'est pas la dernière de la page, on applique ceci -->
                        <xsl:when test="position()!=last()">
                            
                            {
                            
                            "@id":"http://demos.biblissima-condorcet.fr/iiif/metadata/BN_Latin2859/list/transscript_<xsl:value-of select="$currentLineNumber"/>.json",
                            "@type":"oa:Annotation",
                            "motivation":"sc:painting",
                            "resource":{
                            "@type":"cnt:ContentAsText",
                            <!-- On exclut l'élément 'head' pour ne pas afficher son contenu dans le texte de la transcription -->
                            <xsl:variable name="teiWithoutHead">
                                <xsl:sequence select="/TEI/teiHeader|/TEI/text/body/div/node()[not(self::head)]"/>
                            </xsl:variable>
                            
                            <!-- On choisit le texte entre le <lb> courant et le <lb> suivant -->
                            <xsl:variable name="line">
                                <xsl:value-of select="$teiWithoutHead//text()[. &gt;&gt; //lb[@n = $currentLineNumber] and . &lt;&lt; //lb[@n = ($currentLineNumber+1)]]"/>
                            </xsl:variable>
                            <!-- On affiche la ligne du texte sans espaces superflus -->
                            "chars":"<xsl:value-of select="normalize-space($line)"/>",
                            
                            "format":"text/plain",
                            "language":"fr-FR"
                            },
                            
                            <!-- la valeur x de l'abscisse du coin supérieur gauche  -->
                            <xsl:variable name="x"><xsl:value-of select="@ulx"/></xsl:variable>
                            <!-- la valeur y de l'ordonnée du coin supérieur gauche  -->
                            <xsl:variable name="y"><xsl:value-of select="@uly"/></xsl:variable> 
                            <!-- largeur = la valeur x de l'abscisse du coin inférieur droit  -  la valeur x de l'abscisse du coin supérieur gauche  -->
                            <xsl:variable name="w"><xsl:value-of select="@lrx - @ulx"/></xsl:variable>
                            <!-- hauteur = la valeur y de l'ordonnée du coin inférieur droit  -  la valeur y de l'ordonnée du coin supérieur gauche  -->
                            <xsl:variable name="h"><xsl:value-of select="@lry - @uly"/></xsl:variable>
                            
                            <xsl:text>"on":"http://gallica.bnf.fr/iiif/ark:/12148/btv1b8423837b/canvas/f</xsl:text><xsl:value-of select="substring-before(substring-after($graphicURL,'http://gallica.bnf.fr/ark:/12148/btv1b8423837b/f'), '.highres')"/><xsl:text>#xywh=</xsl:text><xsl:value-of select="($x)"/><xsl:text>,</xsl:text><xsl:value-of select="($y)"/><xsl:text>,</xsl:text><xsl:value-of select="($w)"/><xsl:text>,</xsl:text><xsl:value-of select="($h)"/><xsl:text>"</xsl:text>
                            
                            }
                        </xsl:when>
                        <!-- Si la ligne est la dernière de la page, on applique ceci -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- Si la ligne n'est pas la dernière du fichier xml (=elle est suivie par d'autres lignes sur les page suivantes), on applique ceci -->
                                <xsl:when test="/TEI/text/body//lb[@n = ($currentLineNumber+1)]">
                                    
                                    {
                                    
                                    "@id":"http://demos.biblissima-condorcet.fr/iiif/metadata/BN_Latin2859/list/transscript_<xsl:value-of select="$currentLineNumber"/>.json",
                                    "@type":"oa:Annotation",
                                    "motivation":"sc:painting",
                                    "resource":{
                                    "@type":"cnt:ContentAsText",
                                    <xsl:variable name="teiWithoutHead">
                                        <xsl:sequence select="/TEI/teiHeader|/TEI/text/body/div/node()[not(self::head)]"/>
                                        
                                    </xsl:variable>
                                    <xsl:variable name="line">
                                        <xsl:value-of select="$teiWithoutHead//text()[. &gt;&gt; //lb[@n = $currentLineNumber] and . &lt;&lt; //lb[@n = ($currentLineNumber+1)]]"/>
                                    </xsl:variable>
                                    "chars":"<xsl:value-of select="normalize-space($line)"/>",
                                    "format":"text/plain",
                                    "language":"fr-FR"
                                    },
                                    
                                    
                                    <xsl:variable name="x"><xsl:value-of select="@ulx"/></xsl:variable>
                                    <xsl:variable name="y"><xsl:value-of select="@uly"/></xsl:variable> 
                                    <xsl:variable name="w"><xsl:value-of select="@lrx - @ulx"/></xsl:variable>
                                    <xsl:variable name="h"><xsl:value-of select="@lry - @uly"/></xsl:variable>
                                    
                                    
                                    <xsl:text>"on":"http://gallica.bnf.fr/iiif/ark:/12148/btv1b8423837b/canvas/f</xsl:text><xsl:value-of select="substring-before(substring-after($graphicURL,'http://gallica.bnf.fr/ark:/12148/btv1b8423837b/f'), '.highres')"></xsl:value-of><xsl:text>#xywh=</xsl:text><xsl:value-of select="($x)"/><xsl:text>,</xsl:text><xsl:value-of select="($y)"/><xsl:text>,</xsl:text><xsl:value-of select="($w)"/><xsl:text>,</xsl:text><xsl:value-of select="($h)"/><xsl:text>"</xsl:text>
                                    
                                    }
                                    
                                </xsl:when>
                                <!-- Si la ligne est la dernière du fichier xml (=elle n'est suivie par aucune autre ligne), on applique ceci -->
                                <xsl:otherwise>
                                    
                                    {
                                    
                                    "@id":"http://demos.biblissima-condorcet.fr/iiif/metadata/BN_Latin2859/list/transscript_<xsl:value-of select="$currentLineNumber"/>.json",
                                    "@type":"oa:Annotation",
                                    "motivation":"sc:painting",
                                    "resource":{
                                    "@type":"cnt:ContentAsText",
                                    <xsl:variable name="lastline"><xsl:value-of select="//text()[. &gt;&gt; //lb[@n = $currentLineNumber]]"/></xsl:variable>
                                    "chars":"<xsl:value-of select="normalize-space($lastline)"/>",
                                    "format":"text/plain",
                                    "language":"fr-FR"
                                    },
                                    
                                    <!-- upper left x  -->
                                    <xsl:variable name="x"><xsl:value-of select="@ulx"/></xsl:variable>
                                    <!-- upper left y  -->
                                    <xsl:variable name="y"><xsl:value-of select="@uly"/></xsl:variable> 
                                    <!-- width = lower right x  -  upper left x  -->
                                    <xsl:variable name="w"><xsl:value-of select="@lrx - @ulx"/></xsl:variable>
                                    <!-- height = lower right y  -  upper left y  -->
                                    <xsl:variable name="h"><xsl:value-of select="@lry - @uly"/></xsl:variable>
                                    
                                    
                                    <xsl:text>"on":"http://gallica.bnf.fr/iiif/ark:/12148/btv1b8423837b/canvas/f</xsl:text><xsl:value-of select="substring-before(substring-after($graphicURL,'http://gallica.bnf.fr/ark:/12148/btv1b8423837b/f'), '.highres')"></xsl:value-of><xsl:text>#xywh=</xsl:text><xsl:value-of select="($x)"/><xsl:text>,</xsl:text><xsl:value-of select="($y)"/><xsl:text>,</xsl:text><xsl:value-of select="($w)"/><xsl:text>,</xsl:text><xsl:value-of select="($h)"/><xsl:text>"</xsl:text>
                                    
                                    }
                                    
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                
                ]
                }		
                
            </xsl:result-document>
        </xsl:for-each>
        
        <!-- On crée le fichier json principal -->
        <xsl:variable name="mainFile">BN_Latin2859_transscript.json</xsl:variable>
        <xsl:result-document href="{$mainFile}" method="text" encoding="UTF-8" indent="yes">
            {
            "@context": "http://iiif.io/api/presentation/2/context.json",
            "@id": "http://demos.biblissima-condorcet.fr/iiif/metadata/BnF_Latin2859_transcript/manifest.json",
            "@type": "sc:Manifest",
            "label": "<xsl:value-of select="/TEI/teiHeader//profileDesc/creation/title/text()"/>",
            "metadata": [
            {
            "label":"Repository",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc//msIdentifier/repository/text()"/>"
            },
            {
            "label": "Shelfmark",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc//msIdentifier/settlement/text()"/>, <xsl:value-of select="/TEI/teiHeader//sourceDesc//msIdentifier/idno/text()"/>"
            },
            {
            "label": "Title",
            "value": "<xsl:value-of select="/TEI/teiHeader//profileDesc/creation/title/text()"/>"
            },
            {
            "label": "Language",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc//msItem/textLang/text()"/>"
            },
            {
            "label": "Material",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc/listWit//physDesc//supportDesc/support/p/text()"/>"
            },
            <xsl:variable name="extent">
                <xsl:value-of select="/TEI/teiHeader//sourceDesc/listWit//physDesc//supportDesc/extent/text()"/>
            </xsl:variable>
            {
            "label": "Extent",
            "value": "<xsl:value-of select="normalize-space($extent)"/>"
            },
            {
            "label": "Dimensions",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc/listWit//physDesc//supportDesc/extent//height/text()"/><xsl:text> X </xsl:text><xsl:value-of select="/TEI/teiHeader//sourceDesc/listWit//physDesc//supportDesc/extent//width/text()"></xsl:value-of>"
            },
            {
            "label": "Provenance",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc/listWit//provenance/origPlace/text()"/>"
            },
            {
            "label": "Creator",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc//msItem/author[@xml:lang='fra']/text()"/>. Auteur du texte"
            },
            {
            "label": "Date",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc/listWit//history//origDate/text()"/>"
            },
            {
            "label": "Provider",
            "value": "<xsl:value-of select="/TEI/teiHeader//sourceDesc//msIdentifier/repository/text()"/>"
            },
            {
            "label": "Disseminator",
            "value": "<xsl:value-of select="/TEI/teiHeader//titleStmt/sponsor/text()"/>"
            },
            {
            "label": "Source Images",
            "value": "http://gallica.bnf.fr/ark:/12148/btv1b8438674r/"
            }
            ],
            "description": "<xsl:value-of select="/TEI/teiHeader//editionStmt/edition/text()"/>",
            "license": "http://creativecommons.org/licenses/by-nc/4.0/",
            "attribution": "<xsl:value-of select="/TEI/teiHeader//respStmt/name/text()"/>",
            "sequences": [{
            "@id": "http://gallica.bnf.fr/iiif/ark:/12148/btv1b8423837b/sequence/normal",
            "@type": "sc:Sequence",
            "label": "Normal",
            "canvases": [
            <xsl:for-each select="/TEI/text/body//pb">
                <xsl:variable name="pbNumber" select="@n"/>
                <xsl:variable name="surfaceID"><xsl:value-of select="substring-after(@facs,'#')"/></xsl:variable>
                <xsl:variable name="graphicURL"><xsl:value-of select="/TEI/facsimile/surface[@xml:id=$surfaceID]/graphic/@url"/></xsl:variable>
                {
                "@id": "http://gallica.bnf.fr/iiif/ark:/12148/btv1b8423837b/canvas/f<xsl:value-of select="substring-before(substring-after($graphicURL,'http://gallica.bnf.fr/ark:/12148/btv1b8423837b/f'), '.highres')"/>",
                "@type": "sc:Canvas",
                "label": "<xsl:value-of select="$pbNumber"/>",
                <xsl:variable name="width"><xsl:value-of select="/TEI/facsimile/surface[@xml:id=$surfaceID]/@lrx"/></xsl:variable>
                <xsl:variable name="height"><xsl:value-of select="/TEI/facsimile/surface[@xml:id=$surfaceID]/@lry"/></xsl:variable>
                "width": <xsl:value-of select="$width"/>,
                "height": <xsl:value-of select="$height"/>,
                "images": [{
                "@type": "oa:Annotation",
                "motivation": "sc:painting",
                "resource": {
                "@id": "<xsl:value-of select="$graphicURL"/>",
                "format": "image/jpg",
                "@type": "dctypes:Image",
                "service": {
                "@context": "http://iiif.io/api/image/1/context.json",
                "profile": "http://library.stanford.edu/iiif/image-api/1.1/compliance.html#level2",
                "@id": "http://gallica.bnf.fr/iiif/ark:/12148/btv1b8423837b/f<xsl:value-of select="substring-before(substring-after($graphicURL,'http://gallica.bnf.fr/ark:/12148/btv1b8423837b/f'), '.highres')"/>"
                },
                "width": <xsl:value-of select="$width"/>,
                "height": <xsl:value-of select="$height"/>
                },
                "on":"http://gallica.bnf.fr/iiif/ark:/12148/btv1b8423837b/canvas/f<xsl:value-of select="substring-before(substring-after($graphicURL,'http://gallica.bnf.fr/ark:/12148/btv1b8423837b/f'), '.highres')"/>"
                }],
                "otherContent": [{
                "@id": "http://demos.biblissima-condorcet.fr/iiif/metadata/BnF_Latin2859_transcript/list/transscript_<xsl:value-of select="$pbNumber"/>.json",
                "@type": "sc:AnnotationList"
                }]
                }
                <xsl:if test="position()!=last()">,</xsl:if>                  
            </xsl:for-each>
            ]
            }
            ]
            }
        </xsl:result-document>
    </xsl:template>
    
    
</xsl:stylesheet>