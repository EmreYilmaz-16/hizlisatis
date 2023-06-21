<cfquery name="getIndexes" datasource="#dsn#">
    /*   select top 10 IndexName=name,
       TypeDescription =type_desc
       ,IndexId=index_id
       ,ObjectId=object_id
       from workcube_metosan.sys.indexes as ind where 1=1
       AND ind.is_primary_key = 0
       AND ind.is_unique = 0
       AND ind.is_unique_constraint = 0
       AND name IS NOT NULL
   */
   
   SELECT DISTINCT
     --  TableName = t.name,
       IndexName = ind.name,
       IndexId = ind.index_id,
       --ColumnId = ic.index_column_id,
       --ColumnName = col.name,
       --SchemaName=SC.name,
       TypeDescription=ind.type_desc,
       ObjectId=ind.object_id
       FROM
       sys.indexes ind
       INNER JOIN
       sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id
       INNER JOIN
       sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id
       INNER JOIN
       sys.tables t ON ind.object_id = t.object_id
       INNER JOIN
       sys.schemas SC ON T.schema_id = SC.schema_id
       WHERE
       ind.is_primary_key = 0
       AND ind.is_unique = 0
       AND ind.is_unique_constraint = 0
       AND t.is_ms_shipped = 0
       AND SC.name='workcube_metosan_product'
       
       ORDER BY
      ind.object_id
   
   </cfquery>
   <cfoutput query="getIndexes">
       <cfquery name="getcOL" datasource="#DSN#">
           SELECT
           TableName = t.name,
           ColumnId = ic.index_column_id,
           ColumnName = col.name,
           SchemaName=SC.name,
           CASE WHEN ic.is_descending_key = 1 then 'DESC' else 'ASC' END as IsDescending
           FROM
           sys.index_columns ic
           INNER JOIN
           sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id
           INNER JOIN
           sys.tables t ON  t.object_id=#ObjectId#
           INNER JOIN
           sys.schemas SC ON T.schema_id = SC.schema_id
           WHERE ic.index_id=#IndexId# and ic.object_id=#ObjectId#  AND t.is_ms_shipped = 0
       </cfquery>
       <cfif getcOL.recordCount>
           CREATE #TypeDescription# INDEX [#IndexName#] ON
   
           <cfset ii=0>
           [#getcOL.SchemaName#].[#getcOL.TableName#](
           <cfloop query="getcOL">
               <cfset ii=ii+1>
               [#ColumnName#] #IsDescending# <cfif ii lt getcOL.recordCount>,</cfif>
   
           </cfloop>
           )
   
       </cfif>
   </cfoutput>
   
   <cfabort>
   <cfquery name="getI" datasource="#dsn#">
       SELECT top 20
       TableName = t.name,
       IndexName = ind.name,
       IndexId = ind.index_id,
       ColumnId = ic.index_column_id,
       ColumnName = col.name,
       SchemaName=SC.name,
       TypeDescr=ind.type_desc,
       ObjectId=ind.object_id
       FROM
       sys.indexes ind
       INNER JOIN
       sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id
       INNER JOIN
       sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id
       INNER JOIN
       sys.tables t ON ind.object_id = t.object_id
       INNER JOIN
       sys.schemas SC ON T.schema_id = SC.schema_id
       WHERE
       ind.is_primary_key = 0
       AND ind.is_unique = 0
       AND ind.is_unique_constraint = 0
       AND t.is_ms_shipped = 0
       ORDER BY
       sc.name,t.name, ind.name, ind.index_id, ic.is_included_column, ic.key_ordinal;
   
   
   
   
   
   </cfquery>
   <cfdump var="#getI#">
   
   <cfoutput query="getI" group="SchemaName">
       #TypeDescr# #SchemaName#
   </cfoutput>


   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous">
</script>
<cfabort>
<div>
   
   
    <cf_box>
       <div>
        Proje<br>
        <div style="display:flex">
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs'" title="Projeler">
                <img src="/images/e-pd/pr.png">
                </a>
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs&amp;list_my_projects=1'" title="Görevlisi Olduğum Projeler">
                <img src="/images/e-pd/mpr.png">
                </a>
            <a class="brtbtn" onclick="openBoxDraggable('index.cfm?fuseaction=project.emptypopup_add_project_fast')" title="Yeni Proje">
                <img src="/images/e-pd/add.png">
               </a>
            <a class="brtbtn">
                <img src="/images/e-pd/rprt.png" title="Proje Raporları" disabled>
                </a>
            <a class="brtbtn" tite="Proje Ürünleri" disabled>
                <img src="/images/e-pd/prp.png">
                </a>
            <a class="brtbtn">
                <img src="/images/e-pd/prts.png" title="Proje Ürün Tipleri" disabled>
                </a>
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_myworks'" title="Bekleyen İşlerim">
                <img src="/images/e-pd/wrks.png">
                </a>
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&amp;act=list_my'" title="Notlarım">
                <img src="/images/e-pd/nt.png">
                </a>
        
        </div>
        
    </div>
    <div>
        Proje<br>
        <div style="display:flex">
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs'" title="Projeler">
                <img src="/images/e-pd/pr.png">
                </a>
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs&amp;list_my_projects=1'" title="Görevlisi Olduğum Projeler">
                <img src="/images/e-pd/mpr.png">
                </a>
            <a class="brtbtn" onclick="openBoxDraggable('index.cfm?fuseaction=project.emptypopup_add_project_fast')" title="Yeni Proje">
                <img src="/images/e-pd/add.png">
               </a>
            <a class="brtbtn">
                <img src="/images/e-pd/rprt.png" title="Proje Raporları" disabled>
                </a>
            <a class="brtbtn" tite="Proje Ürünleri" disabled>
                <img src="/images/e-pd/prp.png">
                </a>
            <a class="brtbtn">
                <img src="/images/e-pd/prts.png" title="Proje Ürün Tipleri" disabled>
                </a>
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_myworks'" title="Bekleyen İşlerim">
                <img src="/images/e-pd/wrks.png">
                </a>
            <a class="brtbtn" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&amp;act=list_my'" title="Notlarım">
                <img src="/images/e-pd/nt.png">
                </a>
        
        </div>
        
    </div>
    </cf_box>
</div>




   