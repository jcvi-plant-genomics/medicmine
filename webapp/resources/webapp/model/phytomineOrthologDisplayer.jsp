<!doctype html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<!-- phytomineOrthologDisplayer.jsp -->
<div id="phytomineOrtholog_displayer" class="collection-table">
<div class="header">
<h3>Phytozome Homologs</h3>
<p>Data Source: <a target="_blank" href="http://phytozome.jgi.doe.gov/phytomine">Phytozome</a></p>
</div>

<c:set var="object" value="${reportObject.object}"/>

<c:choose>
<c:when test="${((!empty object.chromosomeLocation && !empty object.chromosome)
                || className == 'Chromosome') && className != 'ChromosomeBand'}">
<br />

<div id="InParanoidDisplayer" class="collection-table imtables-dashboard container-fluid imtables">
  <c:set var="name" value="${object.primaryIdentifier}"/>

  <c:choose>
  <c:when test="${WEB_PROPERTIES['phytomine.homolog.prefix'] != null}">
<link rel="stylesheet" type="text/css" href="${WEB_PROPERTIES['head.cdn.location']}/js/intermine/im-tables/latest/imtables.css">
 <div id="phytomine-homolog-container">
 <!-- temporarily removed
   <p class="apology">
     Please be patient while the results of your query are retrieved.
   </p>
   -->
 </div>

 <script type="text/javascript">

   var geneId = "${name}";
   // for local test only
   //var webapp_root_url="http://phytozome.jgi.doe.gov/phytomine/";
   var webapp_root_url = "${WEB_PROPERTIES['phytomine.homolog.prefix']}";

   var options = {
     type: 'table',
     url: webapp_root_url,
     query: {"model":{"name":"genomic"},"select":["Homolog.gene2.name","Homolog.organism2.shortName","Homolog.gene2.briefDescription"],"constraintLogic":"A and B","where":[{"path":"Homolog.organism1.taxonId","op":"=","code":"A","value":"3880"},{"path":"Homolog.gene1.name","op":"=","code":"B","value":geneId}]},
     properties: { pageSize: 10 }
    };

   var wrapSpan = function(text){
       return '<span>'+text+'</span>';
    };

   var formatLink = function(url, text, target, cls){
     target = target || "_self";
     text = text || url;

    if (cls == 'extlink') {
          return '<a class="'+cls+'" href="'+url+'" target="'+target+'">' + text + '</a>';
       } else {
          return '<a href="'+url+'" target="'+target+'">' + text + '</a>';
       }
     };

    var formatPhytomineLink = function(id, dataClass, pattern, value) {
        var thalemine_url = '/${WEB_PROPERTIES['webapp.path']}' + '/portal.do?class=' + dataClass + '&externalids=' + id;
        var phytomine_url = '${WEB_PROPERTIES['intermines.phytomine.url']}' + '/portal.do?class=' + dataClass + '&externalids=' + id;
        if (typeof value === 'undefined') {
            value = id;
        }
        var re = new RegExp(pattern);
        if (re.test(id)) {
            return formatLink(thalemine_url, wrapSpan(value), "_blank", 'internal');
        } else {
            return formatLink(phytomine_url, wrapSpan(value), "_blank", 'extlink');
        }
    };

    var phytomineGeneFormatter = function(o) {
        return formatPhytomineLink(o.get('name'), "Gene", "^Medtr", undefined);
    };

    var phytomineOrganismFormatter = function(o) {
        return formatPhytomineLink(o.get('shortName'), "Organism", "truncatula$", undefined);
    };

    var phytomineDeflineFormatter = function(o) {
        return formatPhytomineLink(o.get('name'), "Gene", "^Medtr", o.get('briefDescription'));
    };

    // new way for using imtables
    imtables.formatting
                .registerFormatter(phytomineGeneFormatter, 'genomic', 'Gene', [ 'name' ]);

    imtables.formatting
                .registerFormatter(phytomineOrganismFormatter, 'genomic', 'Organism', [ 'shortName' ]);

    imtables.formatting
                .registerFormatter(phytomineDeflineFormatter, 'genomic', 'Gene', [ 'briefDescription' ]);


    // note: imtables.loadTable delivers a table without controls (only pagination)
    imtables.loadDash('#phytomine-homolog-container',
        {start : 0, size : 25},
        {service : {root : options.url},
            query : options.query}
        ).then(
            withTable,
            FailureNotification.notify
        );

        function withTable(table) {
            table.bus.on('list-action:failure', LIST_EVENTS['list-creation:failure']);
            table.bus.on('list-action:success', LIST_EVENTS['list-creation:success']);
        }
    </script>

  </c:when>
  <c:otherwise>
     <p>There was a problem rendering the homolog data</code>.</p>
  <script type="text/javascript">
    jQuery('#InParanoidDisplayer').addClass('warning');
  </script>
  </c:otherwise>
  </c:choose>
</c:when>
<c:otherwise>
  <p style="font-style:italic;">No homolog data available</p>
</c:otherwise>
</c:choose>
</div>
<!-- /phytomineOrthologDisplayer.jsp -->
