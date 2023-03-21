<cfcomponent>
   <cffunction name="savePumpa" access="remote" returntype="string" returnformat="JSON" httpMethod="POST">    
        <cfloop from="1" to="#arguments.BozulacakUrunlerArrLen#" index="ix">
            <cfoutput>
               #arguments.BozulacakUrunlerArrLen[ix][DESCRIPTION]#
            </cfoutput>
        </cfloop>
   </cffunction>
</cfcomponent>