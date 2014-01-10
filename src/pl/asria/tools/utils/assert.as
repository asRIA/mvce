package pl.asria.tools.utils 
{
	
	public function assert(object:*):Boolean
	{
		if (object == null) throw new ArgumentError("Assertion error");
	}

}