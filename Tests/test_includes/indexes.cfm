<cfquery name="getI" datasource="#dsn#">
    SELECT top 20
    TableName = t.name,
    IndexName = ind.name,
    IndexId = ind.index_id,
    ColumnId = ic.index_column_id,
    ColumnName = col.name,
    SchemaName=SC.name,
    TypeDescr=ind.type_desc,
    CASE WHEN ic.is_descending_key = 1 then 'DESC' else 'ASC' END as IsDescending,
        (SELECT COUNT(*) FROM sys.index_columns icA WHERE ind.object_id = icA.object_id and ind.index_id = icA.index_id) AS CNN
   /* ind.*,
    ic.*,
    col.* ,
    'CREATE '+ind.type_desc+' INDEX ' +SC.name+' '+T.name+' ('+ col.name +' '+CASE WHEN ic.is_descending_key = 1 then 'DESC' else 'ASC' END+' )' collate Latin1_General_CI_AS_KS_WS*/
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