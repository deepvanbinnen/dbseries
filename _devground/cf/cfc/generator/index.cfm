<cfparam name="form.componentname" default="">
<cfparam name="form.componentvariables" default="">
<cfparam name="form.componentthisscope" default="">
<cfparam name="form.componentmethods" default="">
<cfparam name="form.createinitmethod" default="1">
<cfparam name="form.componentinitmethod" default="">
<cfparam name="form.componentinitargsauto" default="1">
<cfparam name="form.componentfilename" default="">
<cfparam name="form.componentfileoverwrite" default="0">
<cfparam name="form.raisederror" default="">
<cfparam name="form.generatedcode" default="">
<cfparam name="form.filegenerated" default="0">
<cfparam name="form.generationtime" default="">


<cfif IsDefined("form.btnsubmit")>
	<cfinclude template="act_component.cfm">
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head><title>Create Component Code</title>
<style type="text/css">
body {
	font-size: 0.8em; 
	line-height: 1.4em; 
	font-family: "Lucida Sans Unicode", Verdana, Arial, Geneva, "Bitstream Sans";
	margin: 0; padding: 0;
}
h1 {position: relative; }
h1 span {font-size: 0.4em; font-weight: normal; position: absolute; right: 0.5em;}
label {display: block;}
label.checkbox {display: inline;}

span.desc {font-size: 0.8em; color: grey; font-weight: bold;}
div.page {float: left; padding: 1%;}
#leftpage {width: 30%; }
#rightpage {width: 65%; border-left: 0.1em solid black;}
.wide #leftpage {width: 65%; }
.wide #rightpage {width: 30%; }

div.box p, div.box div.float {float: left; width: 49%; }
div.box p {margin: 0.25em 0;}
div.box div.float {width: 30%;}
div.box, .clear {clear: both;}
textarea {width: 98%;}
div.box p.wide {width: 100%;}
p.submit {clear: both; padding-top: 1em; border-top: 1px solid grey; }
</style>
</head><body>

<script type="text/javascript">
var toggleWide = function(){
	var c = document.getElementById("canvas");
	c.className = (c.className=="wide") ? "" : "wide";
} 
</script>

<div id="canvas">
	<div id="leftpage" class="page">
		<h1>Component Code Generator<span><a href="##" onclick="toggleWide();return false;">Toggle wide view</a></span></h1>
		
		<cfoutput>
			<cfset action = CGI.SCRIPT_NAME>
			<!--- <cfset action = "final.cfm"> --->
			<form name="createcomponent" id="createcomponent" method="post" action="#action#">
				<p>
				<input type="checkbox" id="componentfileoverwrite" name="componentfileoverwrite" value="1"<cfif form.componentfileoverwrite eq 1> checked="checked"</cfif> />
				<label class="checkbox" for="componentfileoverwrite">Overwite Existing?</label>
				</p>
				<p>
				<label for="componentfilename">Output file @</label>
				<input type="text" id="componentfilename" name="componentfilename" value="#form.componentfilename#" size="60" />
				</p>
				
				
				<p><label for="componentname">Name</label>
				<input type="text" id="componentname" name="componentname" value="#form.componentname#" />
				</p>
				<div class="box">
					<p>
						<label for="componentthisscope">Public Getter-/Setter-variable</label>
						<textarea id="componentthisscope" name="componentthisscope" cols="40" rows="10">#form.componentthisscope#</textarea>
					</p>
					
					<p>
						<label for="componentvariables">Private Getter-/Setter-variable</label>
						<textarea id="componentvariables" name="componentvariables" cols="40" rows="10">#form.componentvariables#</textarea>
					</p>
					<p class="clear wide">
						<span class="desc">Syntax: [name] [cfdatatype] [required] [default]</span>
					</p>
				</div>
				
				<div class="box">
					<label for="componentmethods">Methods </label>
					<textarea id="componentmethods" name="componentmethods" cols="40" rows="10">#form.componentmethods#</textarea>
					<p class="clear wide">
					<span class="desc">Syntax: @[name] [params (list,..)] [requireds (list,..)] [rettype] [retval]
					</span>
					</p>
				</div>
				
				<div class="box">
					<div class="float">
						<p class="clear"><label class="checkbox" for="createinitmethod">Create Init-method</label><br />
						<input type="checkbox" id="createinitmethod" name="createinitmethod" value="1"<cfif form.createinitmethod eq 1> checked="checked"</cfif> />
						</p>
						<p class="clear"><label class="checkbox" for="componentinitargsauto">Autoset init-method-args</label><br />
						<input type="checkbox" id="componentinitargsauto" name="componentinitargsauto" value="1"<cfif form.componentinitargsauto eq 1> checked="checked"</cfif> />
						</p>
					</div>
					<p><label for="componentinitmethod">Init-method-vars</label>
					<textarea id="componentinitmethod" name="componentinitmethod" cols="40" rows="3">#form.componentinitmethod#</textarea>
					<span class="desc"><br />
					Syntax:<br />
					@first-line: variable-names as list<br />
					@second-line: required variable-names as list
					</span>
					</p>
				</div>
				<p class="submit"><input type="submit" name="btnsubmit" id="btnsubmit" value="Create Code" /></p>
				<input type="hidden" name="generatedcode" id="generatedcode" value="#URLEncodedFormat(form.generatedcode)#" />
			</form>
		</cfoutput>
	</div>
	<div id="rightpage" class="page">
		<h2>Generated code</h2>
		<cfif generatedcode neq "">
			<cfif form.componentfilename neq "">
				<cfif form.filegenerated eq 1>
					<p>Generated file: <cfoutput><strong>#form.componentfilename#</strong></cfoutput></p>
				<cfelseif form.raisederror neq "">
					<p><cfoutput><strong>#form.raisederror#</strong></cfoutput></p>
				</cfif>
			</cfif>
			<cfoutput><p><span class="desc">Code generated in: #form.generationtime#ms</span></p></cfoutput>
		</cfif>
		<textarea id="generatedcode" name="generatedcode" style="width: 100%;" cols="120" rows="50"><cfoutput>#URLDecode(form.generatedcode)#</cfoutput></textarea>
		
	</div>
	
</div>

</body>
</html>

