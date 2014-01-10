package pl.asria.tools.media.sound 
{
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	
	public function concatenateSoundTransform(...transforms):SoundTransform
	{
		var resuult:SoundTransform = new SoundTransform();
		var pan:Number = 0;
		for each (var item:SoundTransform in transforms) 
		{
			if (item == null) continue;
			resuult.rightToLeft *= item.rightToLeft;
			resuult.rightToRight *= item.rightToRight;
			resuult.leftToRight *= item.leftToRight;
			resuult.leftToLeft *= item.leftToLeft;
			resuult.volume *= item.volume;
			pan += item.pan;
		}
		resuult.pan /= transforms.length;
		return resuult;
	}

}