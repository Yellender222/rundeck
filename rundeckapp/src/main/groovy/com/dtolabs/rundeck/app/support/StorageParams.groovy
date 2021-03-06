/*
 * Copyright 2014 SimplifyOps Inc, <http://simplifyops.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.dtolabs.rundeck.app.support

import grails.validation.Validateable

/**
 * StorageParams is ...
 * @author Greg Schueler <a href="mailto:greg@simplifyops.com">greg@simplifyops.com</a>
 * @since 2014-09-30
 */
class StorageParams implements Validateable{
    String resourcePath
    String relativePath
    String fileName
    String inputType
    String uploadKeyType
    static constraints={
        resourcePath(nullable: true, matches: /^\/?((?!\.\.(\/|$))[a-zA-Z0-9,\.+_-][\sa-zA-Z0-9,\.+_-]*?\/?)+$/)
        relativePath(nullable: true, matches: /^\/?((?!\.\.(\/|$))[a-zA-Z0-9,\.+_-][\sa-zA-Z0-9,\.+_-]*?\/?)+$/)
        fileName(nullable: true, matches: /^(?!\.\.(\/|$))[a-zA-Z0-9,\.+_-][\sa-zA-Z0-9,\.+_-]*$/)
        inputType(nullable: true, inList: ['file','text'])
        uploadKeyType(nullable: true,inList: ['private','public','password'])
    }

    void requireRoot(String rootPath) {
        if (!this.resourcePath?.startsWith(rootPath)) {
            this.errors.rejectValue('resourcePath', 'invalid')
        }
        if (this.resourcePath?.length() <= rootPath.length()) {
            this.errors.rejectValue('resourcePath', 'invalid')
        }
    }
}
