# TEI2JSON

The repository contains an XML text file and its XSL 2.0 transformation to JSON-LD.

Both were created during my internship at Biblissima (April – July 2015): http://www.biblissima-condorcet.fr

The XML file is a TEI P5 encoding of the treatise titled Absolutio cuiusdam quaestionis by Florus de Lyon, copied in BnF Latin 2859 (60v-72v, written around 850).

The XSLT stylesheet transforms the XML/ TEI file in JSON-LD format to be shown in Mirador viewer (http://projectmirador.org/). Multiple JSON files are created as a result of this transformation: the manifest containing a list of canvases (images) with a link to files with transcription and the aforementioned files with transcription (one JSON file per page, recto or verso).

The demo showing the images and the aligned transcription can be seen here: http://demos.biblissima-condorcet.fr/florus/#absolutio 
