<%--
  Created by IntelliJ IDEA.
  User: greg
  Date: 9/29/14
  Time: 3:04 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="base"/>
    <meta name="tabpage" content="configure"/>
    <title>Storage</title>
    <asset:javascript src="storageBrowseKO.js"/>
    <g:javascript>
        var storageBrowse;
        function init() {
            var rootPath = 'keys';
            storageBrowse = new StorageBrowser(appLinks.storageKeysApi, rootPath);
            storageBrowse.staticRoot(true);
            storageBrowse.browseMode('browse');
            storageBrowse.allowUpload(true);
            storageBrowse.allowNotFound(true);
            ko.applyBindings(storageBrowse);
            jQuery('#storageupload').find('.obs-storageupload-select').on('click', function (evt) {
                var file = jQuery('#storageuploadfile').val();
                console.log("upload: " + file);
                jQuery('#uploadForm')[0].submit();
            });
            var data = loadJsonData('storageData');
            storageBrowse.browse(null,null,data.resourcePath?data.resourcePath:null);
        }
        jQuery(init);
    </g:javascript>
</head>

<body>
<g:embedJSON id="storageData" data="[resourcePath:params.resourcePath]"/>
<div class="row">
    <div class="col-sm-12">
        <g:render template="/common/messages"/>
    </div>
</div>

<div class="row">
    <div class="col-sm-3">
        <g:render template="configNav" model="[selected: 'storage']"/>
    </div>

    <div class="col-sm-9">
        <h3><g:message code="gui.menu.KeyStorage" /></h3>

        <div class="well well-sm">
            <div class="text-info">
                <g:message code="page.keyStorage.description" />
            </div>
        </div>

        <g:render template="/framework/storageBrowser"/>

        %{--modal file delete confirmation--}%
        <div class="modal" id="storageconfirmdelete" tabindex="-1" role="dialog"
             aria-labelledby="storageconfirmdeletetitle"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"
                                aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="storageconfirmdeletetitle">Delete Selected Key</h4>
                    </div>

                    <div class="modal-body" style="max-height: 500px; overflow-y: scroll">
                        <p>Really delete the selected key at this path?</p>

                        <p><strong data-bind="text: selectedPath()"
                                   class="text-info"></strong></p>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-default"
                                data-dismiss="modal">Cancel</button>

                        <button
                               data-bind=" click: $root.delete"
                               data-dismiss="modal"
                               class="btn btn-sm btn-danger obs-storagedelete-select"
                               >Delete</button>
                    </div>
                </div>
            </div>
        </div>

        %{--modal storage key upload/input form--}%
        <g:uploadForm controller="storage" action="keyStorageUpload" id="uploadKeyForm" useToken="true" class="form-horizontal" role="form">
        <div class="modal" id="storageuploadkey" tabindex="-1" role="dialog"
             aria-labelledby="storageuploadtitle2"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"
                                aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="storageuploadtitle2">Add or Upload a Key</h4>
                    </div>

                    <div class="modal-body" style="max-height: 500px; overflow-y: scroll">

                        <div class="form-group">
                            <label for="storageuploadtype" class="col-sm-3 control-label">
                               Key Type:
                            </label>
                            <div class="col-sm-9">
                                <select name="uploadKeyType" id="storageuploadtype" class="form-control" data-bind="value: upload.keyType">
                                    <option value="private">Private Key</option>
                                    <option value="public">Public Key</option>
                                    <option value="password">Password</option>
                                </select>
                                <div class="help-block">
                                    Private Keys and Passwords are not available to download once they are stored. Public keys can be downloaded.
                                </div>
                            </div>
                        </div>

                        <div class="form-group"
                             data-bind="css: { 'has-warning': !upload.validInput(), 'has-success': upload.validInput() }">
                            <div  class="col-sm-3">

                                <select class="form-control" data-bind="value: upload.inputType"
                                        name="inputType">
                                    <option value="text">Enter text</option>
                                    <option value="file">Upload File</option>
                                </select>
                            </div>
                            <div class="col-sm-9">

                                <div data-bind="if: upload.inputType()=='text' && upload.keyType()!='password' ">
                                    <textarea class="form-control" rows="5" id="storageuploadtext"
                                        data-bind="value: upload.textArea"
                                              name="uploadText"></textarea>
                                </div>

                                <div data-bind="visible: upload.inputType()=='file' ">
                                    <input type="file" name="storagefile" id="storageuploadfile" data-bind="value: upload.file"/>
                                </div>

                                <div data-bind="if: upload.inputType()=='text' && upload.keyType()=='password' ">
                                    <input name="uploadPassword" type="password" placeholder="Enter a password"
                                        data-bind="value: upload.password"
                                           id="uploadpasswordfield" class="form-control"/>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="uploadResourcePath2" class="col-sm-3 control-label">
                                Storage path:
                            </label>

                            <div class="col-sm-9">
                                <div class="input-group">
                                    <div class="input-group-addon" data-bind="if: staticRoot()">
                                        <span data-bind="text: rootPath() + '/'"></span>
                                    </div>
                                <input data-bind="value: inputPath, valueUpdate: 'keyup' "
                                       id="uploadResourcePath2" name="relativePath"
                                       class="form-control" placeholder="Enter the directory name"/>
                                </div>
                            </div>
                        </div>

                        <div class="form-group"
                             data-bind="css: { 'has-warning': !upload.fileName()&&upload.inputType()!='file', 'has-success': upload.fileName() && upload.inputType()!='file' }">
                            <label for="uploadResourceName2" class="col-sm-3 control-label">
                                Name:
                            </label>

                            <div class="col-sm-9">
                                <input id="uploadResourceName2"
                                       data-bind="value: upload.fileName, valueUpdate: 'keyup' "
                                       name="fileName" class="form-control"
                                       placeholder="Specify a name."/>

                                <div class="help-block"
                                     data-bind="if: upload.inputType() == 'file'">
                                    If not set, the name of the uploaded file is used.
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class=" col-sm-offset-3 col-sm-9">
                                <div class="checkbox">
                                    <label>
                                    <input type="checkbox" value="true" name="dontOverwrite"/>
                                    Do not overwrite a file with the same name.
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-12">
                                <div class="help-block">
                                    <p>You can reference this stored Key using the storage path:</p>

                                    <p><strong data-bind="text: upload.inputFullpath()"
                                               class="text-info"></strong></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-default"
                                data-dismiss="modal">Cancel</button>

                        <input
                                type="submit"
                                class="btn btn-sm btn-success obs-storageupload-select"
                            data-bind="attr: { disabled: !upload.validInput() }"
                                value="Save"
                        />
                    </div>
                </div>
            </div>
        </div>
        </g:uploadForm>



    </div>
</div>
</body>
