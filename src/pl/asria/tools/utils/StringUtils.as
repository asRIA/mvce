package pl.asria.tools.utils
{
	public class StringUtils
	{
		public static const ALPHABET_FULL:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		public static const ALPHABET_CHARS:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		public static const ALPHABET_NUMERIC:String = "0123456789";
		public function StringUtils()
		{
			
		}
		public static function generateRandomString(newLength:uint = 1, userAlphabet:String = StringUtils.ALPHABET_FULL, extendWithTimespamp:Boolean = true ):String
		{
			var alphabet:Array = userAlphabet.split("");
			var alphabetLength:int = alphabet.length;
			var randomLetters:String = "";
			
			for (var i:uint = 0; i < newLength; i++)
			{
				randomLetters += alphabet[randomIntTo(alphabetLength)];
			}
		if (extendWithTimespamp) randomLetters += (new Date() as Date).getTime();
		return randomLetters;
		}
		public static function removeReplaced(source:String, singleElement:String):String
		{
			var tmp:String;
			trace("---" + source + "----");
			while (source != tmp)
			{
				if (null != tmp) source = tmp;
				tmp = source.replace(singleElement+singleElement,singleElement);
			} 
			trace("---" + tmp + "----");
			return tmp;
		}
		public static function consSizeStringNum(a:Number, l:Number):String
		{
			var ret:String = '';
			a += Math.pow(10, l);
			ret = String(a);
			return ret.slice(ret.length - l);
		}
		public static function cosntSekwenceRepeater(sekwence:String, repeat:Number):String
		{
			var ret:String = "";
			while (repeat > 0)
			{
				ret += sekwence;
				repeat--;
			}
			return ret;
		}
		public static function insertCommasToNumber(number:Number):String
		{
			var numString:String = number.toString();
			var result:String = '';
		
			while (numString.length > 3)
			{
				var chunk:String = numString.substr( -3);
				numString = numString.substr(0, numString.length - 3);
				result = ',' + chunk + result;
			}
		
			if (numString.length > 0)
			{
				result = numString + result;
			}
		
			return result;
		}
		/*
		public static function consElStringNum(n:Number, numOfElement:Number):String
		{
			var ret:String = "";
			if ((Math.pow(10, numOfElement + 1) - 1) < n)
			{
				return consElStringNum(n % (Math.pow(10, numOfElement + 1), numOfElement);
			}
			else
			{
				for (var i:int = numOfElement; i >= 1; i++) 
				{
					
				}
			}
		}
		*/
	}
	
}