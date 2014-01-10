/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-13 09:31</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.secure 
{
	import com.adobe.crypto.MD5;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	public class SecureXML 
	{
	
		/**
		 * SecureXML - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SecureXML() 
		{
			
		}
		
		public static function genSecureData(xmlData:XML):String
		{
			// get pure xml string
			var pureData:String;
			var settings:Object = XML.settings();
			XML.prettyIndent = 0;
			XML.prettyPrinting = false;
			pureData = xmlData.toXMLString();
			XML.setSettings(settings);
			
			//base 64 code
			var encoder:Base64Encoder =  new Base64Encoder();
			encoder.encodeUTFBytes(pureData);
			var data64:String = encoder.flush();
			
			return MD5.hash(data64)
		}
		
		public static function validate(xmlData:XML, hash:String):Boolean
		{
			var currentHash:String = genSecureData(xmlData);
			return  currentHash == hash;
		}
		
	}

}