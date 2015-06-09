/*
 * eGovFrame LDAP조직도관리
 * Copyright The eGovFrame Open Community (http://open.egovframe.go.kr)).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * @author 전우성(슈퍼개발자K3)
 */
package egovframework.com.ext.ldapumt.service.impl;

import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;

import egovframework.com.ext.ldapumt.service.LdapObject;

import javax.naming.NamingException;
import javax.naming.directory.Attributes;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.ldap.core.ContextMapper;
import org.springframework.ldap.core.DirContextAdapter;

/**
*
* LDAP에서 조회된 결과를 vo에 맵핑해주는 클래 
* @author 전우성
* @since 2014.10.12
* @version 1.0
* @see
*
* <pre>
* << 개정이력(Modification Information) >>
*
*   수정일      수정자           수정내용
*  -------    --------    ---------------------------
*   2014.10.12  전우성          최초 생성
*
* </pre>
*/
public class ObjectMapper<T> implements ContextMapper<Object> {

	private Class<T> type;

	public ObjectMapper(Class<T> class1) {
		this.type = class1;
	}

	/**
	 * ContextAdapter에서 받아온 객체를 vo로 변환한다.
	 */
	public Object mapFromContext(Object arg0) throws NamingException {
		DirContextAdapter adapter = (DirContextAdapter)arg0;
		Attributes attrs = adapter.getAttributes();
		
		LdapObject vo = null;
		
		try {
			vo = (LdapObject) type.newInstance();
		} catch (Exception e2) {
			throw new RuntimeException(e2);
		}

		vo.setDn(adapter.getDn().toString());
		
		BeanInfo beanInfo;
		try {
			beanInfo = Introspector.getBeanInfo(type);
		} catch (IntrospectionException e1) {
			throw new RuntimeException(e1);
		}

		PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();

		for (PropertyDescriptor descriptor : propertyDescriptors) {
			if (attrs.get(descriptor.getName()) != null)
				try {
					Class<?> o = descriptor.getPropertyType();
					if (o == int.class)
						PropertyUtils.setProperty(vo, descriptor.getName(),
								Integer.valueOf((String) attrs.get(descriptor.getName()).get()));
					if (o == String.class)
						PropertyUtils.setProperty(vo, descriptor.getName(), (String) attrs.get(descriptor.getName()).get());
					if (o == Boolean.class)
						PropertyUtils.setProperty(vo, descriptor.getName(),
								((String) attrs.get(descriptor.getName()).get()).equals("Y"));

				} catch (Exception e) {
					throw new RuntimeException(e);
				}
		}


		return vo;
	}

}
