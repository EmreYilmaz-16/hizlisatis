<style>
    .divElement{
    position: absolute;
    top: 50%;
    left: 50%;
    margin-top: -50px;
    margin-left: -50px;
    width: 100px;
    height: 100px;
    }
</style>
<cfquery name="getDep" datasource="#dsn#">
    SELECT * FROM DEPARTMENT WHERE DEPARTMENT_ID IN (44,45,46,47)
</cfquery>

<div style="width:50%;" class="divElement">
    <cf_box title="Hazirlama TV">
    <div class="form-group">
        <label>Departman</label>
        <select name="dep" id="dep" required onchange="getLocation(this.value)">
            <option value="">Seçiniz</option>
            <cfoutput query="getDep">
                <option value="#DEPARTMENT_ID#">
                    #DEPARTMENT_HEAD#
                </option>
            </cfoutput>
        </select>
    </div>
    <div class="form-group">
        <label>Lokasyon</label>
        <select name="loc" id="loc" required>
        
        </select>
    </div>
<button class="btn btn-success" onclick="loginTv()">Giriş Yap</button>
</cf_box>
</div>
<script>
    function getLocation(id){
        var q=wrk_query("SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION where DEPARTMENT_ID="+id,"dsn")
        console.log(q)
        var sel=document.getElementById("loc");
        sel.innerHTML="";
        var opt=document.createElement("option");
        opt.setAttribute("value","")
        opt.innerText="Seçiniz";            
        sel.appendChild(opt);

        for(let i=0;i<q.recordcount;i++){
            var opt=document.createElement("option");
            opt.setAttribute("value",q.LOCATION_ID[i])
            opt.innerText=q.COMMENT[i]
            sel.appendChild(opt);
        }
    }
    function loginTv(){
        var dep=document.getElementById("dep").value
        var loc=document.getElementById("loc").value
        window.location.href="/index.cfm?fuseaction=stock.emptypopup_hazirlama_tv_after&department_id="+dep+"&location_id="+loc
    }
</script>