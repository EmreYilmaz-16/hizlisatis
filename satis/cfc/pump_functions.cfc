﻿<cfcomponent>
   <cffunction name="savePumpa" access="remote" returntype="string" returnformat="JSON" httpMethod="POST">    
      <cfdump var="#arguments#" >
      <!--- <cfloop from="1" to="#arguments.BozulacakUrunlerArrLen#" index="ix">
            <cfoutput>
               #arguments.BozulacakUrunler[ix]["DESCRIPTION"]#
            </cfoutput>
        </cfloop>--->
   </cffunction>
</cfcomponent>