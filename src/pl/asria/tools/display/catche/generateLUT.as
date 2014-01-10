/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-25 16:51</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.catche 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import pl.asria.tools.managers.animation.AnimationManagerEvent;

	 /**
	  * 
	  * @param	animationDefinition
	  * @param	timeToLokalKeepAlive in ms, default: 1000*60*5
	  * @return
	  */
	public function generateLUT(animations:Object, timeToLokalKeepAlive:int = 300000):Object
	{
		var lut:Object = { };
		for (var key:String in animations) 
		{
			var __animationCache:CachedSeqwence;
			var __animation:MovieClip = animations[key].animation;
			
			
			switch(String(animations[key].cache))
			{
				
				case "local": 
					{
						__animationCache = new CachedSeqwence(__animation, null, CachedSeqwence.CACHE_MODE_DIRECT);
						addBasicCacheScript(__animationCache, __animation.totalFrames-1, new Event(AnimationManagerEvent.COMPLETE_LABEL))
						lut[key] = __animationCache;
						__animationCache.keepFromGC(timeToLokalKeepAlive);
						break;
					}
				case "global": 
					{
						__animationCache = new CachedSeqwence(__animation, null, CachedSeqwence.CACHE_MODE_DIRECT);
						addBasicCacheScript(__animationCache, __animation.totalFrames-1, new Event(AnimationManagerEvent.COMPLETE_LABEL))
						lut[key] = __animationCache;
						__animationCache.keepFromGC(-1);
						break;
					}
				default:
					{
						trace("3:Unsupported cache settings, please choose one from 'local', 'global' or 'none'. Default mapped to 'none'")
					}
				case "none": 
					{
						addBasicCacheScript(__animation, __animation.totalFrames-1, new Event(AnimationManagerEvent.COMPLETE_LABEL))
						lut[key] = __animation;
						break;
					}
			}
		}
		return lut;
	}
		


}