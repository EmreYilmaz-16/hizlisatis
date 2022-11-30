<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">
  <cfoutput>
  	<tr class="color-row">
      <td width="25" align="center"><a href="<cfoutput>#request.self#?fuseaction=pda.list_shipping_store</cfoutput>"><img src="/images/forklift.gif" align="absmiddle" border="0" alt="Sevkiyat Kontrol"></a></td>
      <td><a href="#request.self#?fuseaction=pda.list_shipping_store"><img src="../../images/arrow.gif" border="0" alt="Sevkiyat Kontrol"> Sevkiyat Kontrol</a></td>
    </tr>
    <tr class="color-row">
      <td width="25" align="center"><a href="<cfoutput>#request.self#?fuseaction=pda.list_shipping_collect_store</cfoutput>"><img src="/images/target_customer.gif" align="absmiddle" border="0" alt="Toplu Sevkiyat Kontrol"></a></td>
      <td><a href="#request.self#?fuseaction=pda.list_shipping_collect_store"><img src="../../images/arrow.gif" border="0" alt="Toplu Sevkiyat Kontrol"> Toplu Sevkiyat Kontrol</a></td>
    </tr>
    <tr class="color-row">
      <td width="25" align="center"><a href="<cfoutput>#request.self#?fuseaction=pda.list_shipping_deliver_store</cfoutput>"><img src="/images/target_branch.gif" align="absmiddle" border="0" alt="Toplu Sevkiyat Kontrol"></a></td>
      <td><a href="#request.self#?fuseaction=pda.list_shipping_deliver_store"><img src="../../images/arrow.gif" border="0" alt="Toplu Sevkiyat Kontrol"> Müşteri Ürün Teslimat</a></td>
    </tr>
  </cfoutput>
</table>