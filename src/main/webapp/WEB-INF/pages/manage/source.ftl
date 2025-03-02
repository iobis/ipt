<#escape x as x?html>
<#include "/WEB-INF/pages/inc/header.ftl">
<title><@s.text name='manage.source.title'/></title>
<script src="${baseURL}/js/jconfirmation.jquery.js"></script>
<script>
    $(document).ready(function(){
        $('.confirm').jConfirmAction({
            titleQuestion: "<@s.text name="basic.confirm"/>",
            question: "<@s.text name="manage.source.confirmation.message"/>",
            yesAnswer: "<@s.text name="basic.yes"/>",
            cancelAnswer: "<@s.text name="basic.no"/>",
            buttonType: "danger"
        });
        $("#peekBtn").click(function (e) {
            e.preventDefault();
            displayProcessing();
            $("#modalcontent").load("peek.do?r=${resource.shortname}&id=${id!}", hideProcessing);
            $("#modalbox").show();
        });
        $("#modalbox").click(function (e) {
            e.preventDefault();
            $("#modalbox").hide();
        });

        $("#generatedSqlLink").click(function (e) {
            e.preventDefault();
            var sqlBlock = $("#generatedSqlBlock");
            if (sqlBlock.is(":hidden")) {
                sqlBlock.slideDown("slow");
            } else {
                sqlBlock.slideUp("slow");
            }
        });

        $("#save").on("click", displayProcessing);
        $("#analyze").on("click", displayProcessing);

        $(document.body).on('click', '.helpOptionLink', function (e) {
            e.preventDefault();
            // get all link classes
            var classes = $(this).attr('class').split(/\s+/);
            var inputName, inputValue

            for (var i = 0; i < classes.length; i++) {
                // get input name in order to set value
                if (classes[i].startsWith('inputName')) {
                    // get rid of prefix, escape dots
                    inputName = classes[i].replace('inputName-', '').replaceAll('.', '\\.');
                }

                // get value to be set
                if (classes[i].startsWith('inputValue')) {
                    // get rid of prefix
                    inputValue = classes[i].replace('inputValue-', '');
                }
            }

            $('#' + inputName).val(inputValue)
        });
    });
</script>
<#assign currentMenu = "manage"/>
<#include "/WEB-INF/pages/inc/menu.ftl">
<#include "/WEB-INF/pages/macros/forms.ftl"/>
<#include "/WEB-INF/pages/macros/popover.ftl"/>

    <form class="topForm needs-validation" action="source.do" method="post" novalidate>
        <div class="container-fluid bg-body border-bottom">
            <div class="container my-3">
                <#include "/WEB-INF/pages/inc/action_alerts.ftl">
            </div>

            <div class="container my-3 p-3">
                <div class="text-center">
                    <div class="text-center text-uppercase fw-bold fs-smaller-2">
                        <nav style="--bs-breadcrumb-divider: url(&#34;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='8'%3E%3Cpath d='M2.5 0L1 1.5 3.5 4 1 6.5 2.5 8l4-4-4-4z' fill='currentColor'/%3E%3C/svg%3E&#34;);" aria-label="breadcrumb">
                            <ol class="breadcrumb justify-content-center mb-0">
                                <li class="breadcrumb-item"><a href="${baseURL}/manage/"><@s.text name="breadcrumb.manage"/></a></li>
                                <li class="breadcrumb-item"><a href="resource?r=${resource.shortname}"><@s.text name="breadcrumb.manage.overview"/></a></li>
                                <li class="breadcrumb-item active" aria-current="page"><@s.text name="breadcrumb.manage.overview.source"/></li>
                            </ol>
                        </nav>
                    </div>

                    <h5 class="pb-2 mb-0 pt-2 text-gbif-header fs-2 fw-400">
                        <@popoverPropertyInfo "manage.source.intro"/>
                        <@s.text name='manage.source.title'/>
                    </h5>

                    <div class="text-smaller">
                        <a href="resource.do?r=${resource.shortname}" title="${resource.title!resource.shortname}">${resource.title!resource.shortname}</a>
                    </div>

                    <div class="mt-2">
                        <#if source??>
                            <@s.submit cssClass="btn btn-sm btn-outline-gbif-primary top-button" name="save" key="button.save"/>
                            <@s.submit cssClass="btn btn-sm btn-outline-gbif-primary top-button" name="analyze" key="button.analyze"/>
                            <a id="peekBtn" href="#" class="btn btn-sm btn-outline-gbif-primary top-button">
                                <@s.text name="button.preview"/>
                            </a>
                            <#if id?has_content>
                                <@s.submit cssClass="confirm btn btn-sm btn-outline-gbif-danger top-button" name="delete" key="button.delete"/>
                            </#if>
                            <@s.submit cssClass="btn btn-sm btn-outline-secondary top-button" name="cancel" key="button.cancel"/>
                        <#else>
                            <@s.submit cssClass="btn btn-sm btn-outline-secondary top-button" name="cancel" key="button.back"/>
                        </#if>
                    </div>
                </div>
            </div>
        </div>

        <div class="container-fluid bg-body">
            <main class="container">
                <div class="my-3 p-3">
                    <div class="row g-3">
                        <input type="hidden" name="r" value="${resource.shortname}" />
                        <input type="hidden" name="id" value="${id!}" />

                        <#if source??>
                            <div class="col-12">
                                <div class="table-responsive">
                                    <table id="source-properties" class="table table-sm table-borderless text-smaller">
                                        <tr>
                                            <th class="col-lg-2 col-md-3"><@s.text name='manage.source.readable'/></th>
                                            <td>
                                                <div>
                                                    <#if source.readable>
                                                        <i class="bi bi-circle-fill text-gbif-primary"></i>
                                                        <span class="text-gbif-primary"><@s.text name="basic.yes"/></span>
                                                    <#else>
                                                        <i class="bi bi-circle-fill text-gbif-danger"></i>
                                                        <span class="text-gbif-danger"><@s.text name="basic.no"/></span>
                                                    </#if>
                                                </div>
                                            </td>
                                        </tr>

                                        <#if source.sourceType == 'URL'>
                                            <tr>
                                                <th><@s.text name='manage.source.url'/></th>
                                                <td><a href="${(source.url)!}">${(source.url)!}</a></td>
                                            </tr>
                                            <#if source.readable>
                                                <tr>
                                                    <th><@s.text name='manage.source.columns'/></th>
                                                    <td>${source.getColumns()}</td>
                                                </tr>
                                                <tr>
                                                    <th><@s.text name='manage.source.rows'/></th>
                                                    <td>${source.rows!"-"}</td>
                                                </tr>
                                                <tr>
                                                    <th><@s.text name='manage.source.size'/></th>
                                                    <td>
                                                        <#if (source.fileSizeFormatted)??>
                                                            <@source.fileSizeFormatted?interpret />
                                                        <#else>
                                                            -
                                                        </#if>
                                                    </td>
                                                </tr>
                                            </#if>
                                            <#if source.lastModified?has_content>
                                                <tr>
                                                    <th><@s.text name='manage.source.modified'/></th>
                                                    <td>${(source.lastModified?datetime?string.long_medium)!}</td>
                                                </tr>
                                            </#if>
                                        <#elseif source.sourceType == 'TEXT_FILE'>
                                            <tr>
                                                <th><@s.text name='manage.source.file'/></th>
                                                <td>${(source.file.getAbsolutePath())!}</td>
                                            </tr>
                                            <tr>
                                                <th><@s.text name='manage.source.columns'/></th>
                                                <td>${source.getColumns()}</td>
                                            </tr>
                                            <tr>
                                                <th><@s.text name='manage.source.rows'/></th>
                                                <td>${source.rows!"-"}</td>
                                            </tr>
                                            <tr>
                                                <th><@s.text name='manage.source.size'/></th>
                                                <td><#if (source.fileSizeFormatted)??>
                                                        <@source.fileSizeFormatted?interpret />
                                                    <#else>
                                                        -
                                                    </#if></td>
                                            </tr>
                                            <tr>
                                                <th><@s.text name='manage.source.modified'/></th>
                                                <td>${(source.lastModified?datetime?string.long_medium)!}</td>
                                            </tr>
                                            <#if (logExists)>
                                                <tr>
                                                    <th><@s.text name='manage.source.source.log'/></th>
                                                    <td><a href="${baseURL}/sourcelog.do?r=${resource.shortname}&s=${source.name}"><@s.text name='manage.source.download'/></a></td>
                                                </tr>
                                            </#if>
                                        </#if>
                                    </table>
                                </div>
                            </div>

                            <div class="text-smaller mt-0">
                                <#if problem??><div class="callout callout-danger my-0">${problem!}</div></#if>
                            </div>

                            <div class="col-lg-6">
                                <@input name="source.name" help="i18n" disabled=id?has_content/>
                            </div>

                            <#-- inputs used by multiple source types -->
                            <#macro multivalue>
                                <@input name="source.multiValueFieldsDelimitedBy" help="i18n" helpOptions={"|":"[ | ] Pipe",";":"[ ; ] Semicolon",",":"[ , ] Comma"}/>
                            </#macro>
                            <#macro dateFormat>
                                <@input name="source.dateFormat" help="i18n" helpOptions={"YYYY-MM-DD":"ISO format: YYYY-MM-DD","MM/DD/YYYY":"US dates: MM/DD/YYYY","DD.MM.YYYY":"DD.MM.YYYY"}/>
                            </#macro>
                            <#macro encoding>
                                <@input name="source.encoding" help="i18n" helpOptions={"UTF-8":"UTF-8","Latin1":"Latin 1","Cp1252":"Windows1252"}/>
                            </#macro>
                            <#macro headerLines>
                                <@input name="source.ignoreHeaderLines" help="i18n" helpOptions={"0":"None","1":"Single Header row"}/>
                            </#macro>

                            <#-- only for sql sources -->
                            <#if source.isSqlSource()>
                                <div class="col-lg-6">
                                    <@select name="rdbms" options=jdbcOptions value="${source.rdbms.name!}" i18nkey="sqlSource.rdbms" />
                                </div>
                                <div class="col-lg-6">
                                    <@input name="sqlSource.host" help="i18n"/>
                                </div>
                                <div class="col-lg-6">
                                    <@input name="sqlSource.database" help="i18n"/>
                                </div>
                                <div class="col-lg-6">
                                    <@input name="sqlSource.username" />
                                </div>
                                <div class="col-lg-6">
                                    <@input name="sqlSourcePassword" i18nkey="sqlSource.password" type="password" />
                                </div>
                                <div class="col-12">
                                    <@text name="sqlSource.sql" help="i18n"/>
                                    <#if sqlSource.sql?has_content>
                                        <div class="mt-3">
                                            <a id="generatedSqlLink" href=""><@s.text name="sqlSource.sqlLimited"/></a>
                                        </div>
                                        <div id="generatedSqlBlock" class="px-1 mt-2 text-smaller" style="display: none;">
                                            <pre>${sqlSource.getSqlLimited(10)!}</pre>
                                        </div>
                                    </#if>
                                </div>
                                <div class="col-lg-6">
                                    <@encoding/>
                                </div>
                                <div class="col-lg-6">
                                    <@dateFormat/>
                                </div>
                                <div class="col-lg-6">
                                    <@multivalue/>
                                </div>

                            <#-- excel source -->
                            <#elseif source.isExcelSource()>
                                <div class="col-lg-6"></div>
                                <div class="col-lg-6">
                                    <@headerLines/>
                                </div>
                                <div class="col-lg-6">
                                    <@select name="source.sheetIdx" options=source.sheets() value="${source.sheetIdx}" i18nkey="excelSource.sheets" />
                                </div>
                                <div class="col-lg-6">
                                    <@multivalue/>
                                </div>

                            <#-- file source -->
                            <#elseif source.isFileSource()>
                                <div class="col-lg-6"></div>
                                <div class="col-lg-6">
                                    <@headerLines/>
                                </div>
                                <div class="col-lg-6">
                                    <@input name="fileSource.fieldsTerminatedByEscaped" help="i18n" helpOptions={"\\t":"[ \\t ] Tab",",":"[ , ] Comma",";":"[ ; ] Semicolon","|":"[ | ] Pipe"}/>
                                </div>
                                <div class="col-lg-6">
                                    <@input name="fileSource.fieldsEnclosedByEscaped" help="i18n" helpOptions={"":"None","&quot;":"Double Quote","&apos;":"Single Quote"}/>
                                </div>
                                <div class="col-lg-6">
                                    <@multivalue/>
                                </div>
                                <div class="col-lg-6">
                                    <@encoding/>
                                </div>
                                <div class="col-lg-6">
                                    <@dateFormat/>
                                </div>
                            <#else>
                                <div class="col-lg-6"></div>
                                <div class="col-lg-6">
                                    <@headerLines/>
                                </div>
                                <div class="col-lg-6">
                                    <@input name="source.fieldsTerminatedByEscaped" i18nkey="fileSource.fieldsTerminatedByEscaped" help="i18n" helpOptions={"\\t":"[ \\t ] Tab",",":"[ , ] Comma",";":"[ ; ] Semicolon","|":"[ | ] Pipe"}/>
                                </div>
                                <div class="col-lg-6">
                                    <@input name="source.fieldsEnclosedByEscaped" i18nkey="fileSource.fieldsEnclosedByEscaped" help="i18n" helpOptions={"":"None","&quot;":"Double Quote","&apos;":"Single Quote"}/>
                                </div>
                                <div class="col-lg-6">
                                    <@multivalue/>
                                </div>
                                <div class="col-lg-6">
                                    <@encoding/>
                                </div>
                                <div class="col-lg-6">
                                    <@dateFormat/>
                                </div>
                            </#if>
                        </#if>
                    </div>
                </div>
            </main>
        </div>
    </form>

<#include "/WEB-INF/pages/inc/footer.ftl">
</#escape>
