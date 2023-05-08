{**
 * plugins/importexport/native/templates/index.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * List of operations this plugin can perform
 *}
{extends file="layouts/backend.tpl"}

{block name="page"}
	<h1 class="app__pageHeading">
		{$pageTitle|escape}
	</h1>
oi gente
<script type="text/javascript">
	// Attach the JS file tab handler.
	$(function() {ldelim}
		$('#importExportTabs').pkpHandler('$.pkp.controllers.TabHandler');
		$('#importExportTabs').tabs('option', 'cache', true);
	{rdelim});
</script>
<div id="importExportTabs" class="pkp_controllers_tab">
	<ul>
		<li><a href="#import-tab">{translate key="aba 01"}</a></li>
		<li><a href="#export-tab">{translate key="aba 02"}</a></li>
	</ul>
	<div id="import-tab">
		<script type="text/javascript">
			$(function() {ldelim}
				// Attach the form handler.
				$('#importXmlForm').pkpHandler('$.pkp.controllers.form.FileUploadFormHandler',
					{ldelim}
						$uploader: $('#plupload'),
							uploaderOptions: {ldelim}
								uploadUrl: {plugin_url|json_encode path="uploadImportXML" escape=false},
								baseUrl: {$baseUrl|json_encode}
							{rdelim}
					{rdelim}
				);
			{rdelim});
		</script>
		<form id="importXmlForm" class="pkp_form" >
			{csrf}
			{fbvFormArea id="importForm"}
				{* Container for uploaded file *}
				

				{fbvFormArea id="file"}
					{fbvFormSection title="Conteudo aba 1"}
						<br><b>Instruções</b><br>
						<p> Este é um teste de construção de plugin para exportar doi de livros para a crossref via xml</p>
						

						<p class="pkp_help">{translate key="plugins.importexport.crossref.settings.depositorIntro"}</p>
						{fbvFormSection}
							{fbvElement type="text" id="depositorName" value=$depositorName required="true" label="plugins.importexport.crossref.settings.form.depositorName" maxlength="60" size=$fbvStyles.size.MEDIUM}
							{fbvElement type="text" id="depositorEmail" value=$depositorEmail required="true" label="plugins.importexport.crossref.settings.form.depositorEmail" maxlength="90" size=$fbvStyles.size.MEDIUM}
						{/fbvFormSection}
						{fbvFormSection}
							<p class="pkp_help">{translate key="plugins.importexport.crossref.registrationIntro"}</p>
							{fbvElement type="text" id="username" value=$username label="plugins.importexport.crossref.settings.form.username" maxlength="50" size=$fbvStyles.size.MEDIUM}
							{fbvElement type="text" password="true" id="password" value=$password label="plugins.importexport.common.settings.form.password" maxLength="50" size=$fbvStyles.size.MEDIUM}
							<span class="instruct">{translate key="plugins.importexport.common.settings.form.password.description"}</span><br/>
						{/fbvFormSection}
						{fbvFormSection list="true"}
							{fbvElement type="checkbox" id="automaticRegistration" label="plugins.importexport.crossref.settings.form.automaticRegistration.description" checked=$automaticRegistration|compare:true}
						{/fbvFormSection}
						{fbvFormSection list="true"}
							{fbvElement type="checkbox" id="testMode" label="plugins.importexport.crossref.settings.form.testMode.description" checked=$testMode|compare:true}
						{/fbvFormSection}






					{/fbvFormSection}
				{/fbvFormArea}

				{fbvFormButtons submitText="common.save"}
			{/fbvFormArea}
		</form>
	</div>


{** parte onde monta a lista de livros*}

	<div id="export-tab">
		{if !$currentContext->getData('publisher') || !$currentContext->getData('location') || !$currentContext->getData('codeType') || !$currentContext->getData('codeValue')}
			{capture assign="contextSettingsUrl"}{url page="management" op="settings" path="context"}{/capture}
			{translate key="plugins.importexport.native.onix30.pressMissingFields" url=$contextSettingsUrl}
		{/if}
		<script type="text/javascript">
			$(function() {ldelim}
				// Attach the form handler.
				$('#exportXmlForm').pkpHandler('$.pkp.controllers.form.FormHandler');
			{rdelim});
		</script>
		<form id="exportXmlForm" class="pkp_form" action="{plugin_url path="export"}" method="post">
			{csrf}
			{fbvFormArea id="exportForm"}
				<submissions-list-panel
					v-bind="components.submissions"
					@set="set"
				>

					<template v-slot:item="{ldelim}item{rdelim}">
						<div class="listPanel__itemSummary">
							<label>
								<input
									type="checkbox"
									name="selectedSubmissions[]"
									:value="item.id"
									v-model="selectedSubmissions"
								/>
								<span class="listPanel__itemSubTitle">
									{{ localize(item.publications.find(p => p.id == item.currentPublicationId).fullTitle) }}<br>
									testeeeee
								<hr>
							
									</span>
							</label>
							
						</div>
					</template>
				</submissions-list-panel>
				{fbvFormSection}
					<pkp-button :disabled="!components.submissions.itemsMax" @click="toggleSelectAll">
						<template v-if="components.submissions.itemsMax && selectedSubmissions.length >= components.submissions.itemsMax">
							{translate key="common.selectNone"}
						</template>
						<template v-else>
							{translate key="common.selectAll"}
						</template>
					</pkp-button>
					<pkp-button @click="submit('#exportXmlForm')">
						{translate key="plugins.importexport.native.exportSubmissions"}
					</pkp-button>
				{/fbvFormSection}
			{/fbvFormArea}
		</form>
	</div>
</div>

{/block}
