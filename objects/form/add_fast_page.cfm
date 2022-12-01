<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<input type="hidden" name="is_submit">
<input type="hidden" name="security" value="Standart">
<input type="hidden" name="is_legacy" value="0">
<input type="text" name="fuseaction_name" placeholder="Full Fuseaction">
<input type="text" name="head" placeholder="Head">
<select name="window_type" id="window_type" required="">
                                        <option value="">Seçiniz </option>
                                        <option value="normal" selected="selected">normal</option>
                                        <option value="popup">popup</option>
                                        <option value="draggable">draggable</option>
                                    </select>
                                    <select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')" required=""></select>
<input type="text" name="head" placeholder="Head">
</cfform>



<script>
	$(document).ready(function(){
		var a=wrk_query("select * from WRK_SOLUTION","DSN")
		var sel=document.getElementById("solution");
		for(let i=0;i<a.recordcount;i++){
			var opt=document.createElement("option");
			opt.setAttribute("value",a.WRK_SOLUTION_ID[i]);
			sel.appendChild(opt);
		}

	})
</script>