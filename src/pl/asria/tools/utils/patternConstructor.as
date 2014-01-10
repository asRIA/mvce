package pl.asria.tools.utils 
{
	 /**
	  * 
	  * @param	base	Every variable in clausure ${test_varialbe}
	  * @param	variables	Name in clausures mus exist in this object
	  * @param	omnitUndefined
	  * @return
	  * @author Piotr Paczkowski - kontakt@trzeci.eu
	  */
	public function patternConstructor(base:String, variables:Object, omnitUndefined:Boolean = false):String
	{
		if (!variables) return base;
		if (base == null) return "";
		var result:String = "";
		var _splitBase:Array = base.split("${");
		result += _splitBase[0];
		if (_splitBase.length > 1)
		{
			for (var i:int = 1; i < _splitBase.length; i++) 
			{
				var _splinx:Array = _splitBase[i].split("}");
				
				if (_splinx.length > 0 )
				{
					if(variables[_splinx[0]] != undefined)
						result += variables[_splinx[0]];
					else if(!omnitUndefined)
						result += "${" +_splinx[0] + "}";
						
					_splinx.shift();
					result += _splinx.join("}");
				}
				else
				{
					result += "${" +_splinx[0];
				}
			}
		}
		return result;
	}
}