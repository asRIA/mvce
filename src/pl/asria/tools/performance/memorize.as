package pl.asria.tools.performance 
{
	import flash.utils.describeType;
	/**
	 * Create dictionared function with cached response
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public function memorize(fn:Function):Function 
	{
		var _cache : Object = { };
		return function(...args):*
		{
			var key : String = "";
			var len:int = args.length;
			if (CONFIG::debug)
			{
				for(var i : int = 0; i < len; i++)
				{
					if(typeof args[i] == "object" )
						throw new ArgumentError("Please to set only primitive values into functions, like: int, String, Number, uint, Boolean");
				}
			}
			key = args.join("\0");
			var result:* = _cache[key];
			return result == undefined ? _cache[key] = fn.apply(null, args) : result;
		}
	}
}