package pl.asria.tools.display.bitmapAtlas
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /** A texture atlas is a collection of many smaller textures in one big image. This class
     *  is used to access textures from such an atlas.
     *  
     *  <p>Using a texture atlas for your textures solves two problems:</p>
     *  
     *  <ul>
     *    <li>There is always one texture active at a given moment. Whenever you change the active
     *        texture, a "texture-switch" has to be executed, and that switch takes time.</li>
     *    <li>Any Stage3D texture has to have side lengths that are powers of two. Starling hides 
     *        this limitation from you, but at the cost of additional graphics memory.</li>
     *  </ul>
     *  
     *  <p>By using a texture atlas, you avoid both texture switches and the power-of-two 
     *  limitation. All textures are within one big "super-texture", and Starling takes care that 
     *  the correct part of this texture is displayed.</p>
     *  
     *  <p>There are several ways to create a texture atlas. One is to use the atlas generator 
     *  script that is bundled with Starling's sibling, the <a href="http://www.sparrow-framework.org">
     *  Sparrow framework</a>. It was only tested in Mac OS X, though. A great multi-platform 
     *  alternative is the commercial tool <a href="http://www.texturepacker.com">
     *  Texture Packer</a>.</p>
     *  
     *  <p>Whatever tool you use, Starling expects the following file format:</p>
     * 
     *  <listing>
     * 	&lt;TextureAtlas imagePath='atlas.png'&gt;
     * 	  &lt;SubTexture name='texture_1' x='0'  y='0' width='50' height='50'/&gt;
     * 	  &lt;SubTexture name='texture_2' x='50' y='0' width='20' height='30'/&gt; 
     * 	&lt;/TextureAtlas&gt;
     *  </listing>
     *  
     *  <p>If your images have transparent areas at their edges, you can make use of the 
     *  <code>frame</code> property of the Texture class. Trim the texture by removing the 
     *  transparent edges and specify the original texture size like this:</p>
     * 
     *  <listing>
     * 	&lt;SubTexture name='trimmed' x='0' y='0' height='10' width='10'
     * 	    frameX='-10' frameY='-10' frameWidth='30' frameHeight='30'/&gt;
     *  </listing>
     */
    public class TextureBitmapAtlas
    {
        private var mAtlasTexture:BitmapData;
        private var mTextureRegions:Dictionary;
        private var mTextureFrames:Dictionary;
        
        /** Create a texture atlas from a texture by parsing the regions from an XML file. */
        public function TextureBitmapAtlas(texture:BitmapData, atlasXml:XML=null)
        {
            mTextureRegions = new Dictionary();
            mTextureFrames  = new Dictionary();
            mAtlasTexture   = texture;
            
            if (atlasXml)
                parseAtlasXml(atlasXml);
        }
        
        /** Disposes the atlas texture. */
        public function dispose():void
        {
            mAtlasTexture.dispose();
        }
        
        /** This function is called by the constructor and will parse an XML in Starling's 
         *  default atlas file format. Override this method to create custom parsing logic
         *  (e.g. to support a different file format). */
        protected function parseAtlasXml(atlasXml:XML):void
        {
            var scale:Number = 1
            for each (var subTexture:XML in atlasXml.SubTexture)
            {
                var name:String        = subTexture.attribute("name");
                var x:Number           = parseFloat(subTexture.attribute("x")) / scale;
                var y:Number           = parseFloat(subTexture.attribute("y")) / scale;
                var width:Number       = parseFloat(subTexture.attribute("width")) / scale;
                var height:Number      = parseFloat(subTexture.attribute("height")) / scale;
                var frameX:Number      = parseFloat(subTexture.attribute("frameX")) / scale;
                var frameY:Number      = parseFloat(subTexture.attribute("frameY")) / scale;
                var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth")) / scale;
                var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight")) / scale;
                
                var region:Rectangle = new Rectangle(x, y, width, height);
                var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?
                        new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
                
                addRegion(name, region, frame);
            }
        }
        
        /** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
        public function getTexture(name:String):BitmapData
        {
            var region:Rectangle = mTextureRegions[name];
            var frame:Rectangle = mTextureFrames[name];
			var targetRect:Rectangle;
			if (frame)
			{
				var result:BitmapData = new BitmapData(frame.width, frame.height, true, 0x00FFFFFF);
				targetRect = new Rectangle( -frame.x, -frame.y, region.width, region.height);
			}
			else
			{
				result = new BitmapData(region.width, region.height, true, 0x00FFFFFF);
				if (region.width > 0 && region.height > 0)
				{
					targetRect = new Rectangle(0,0,region.width, region.height)
					
				}
			}
			if(targetRect) result.setVector(targetRect, mAtlasTexture.getVector(region))
			
           return result
        }
        
        /** Returns all textures that start with a certain string, sorted alphabetically
         *  (especially useful for "MovieClip"). */
        public function getTextures(prefix:String=""):Vector.<BitmapData>
        {
            var textures:Vector.<BitmapData> = new <BitmapData>[];
            var names:Vector.<String> = new <String>[];
            var name:String;
            
            for (name in mTextureRegions)
                if (name.indexOf(prefix) == 0)                
                    names.push(name);                
            
            names.sort(Array.CASEINSENSITIVE);
            
            for each (name in names) 
                textures.push(getTexture(name)); 
            
            return textures;
        }
        
        /** Returns the region rectangle associated with a specific name. */
        public function getRegion(name:String):Rectangle
        {
            return mTextureRegions[name];
        }
        
        /** Returns the frame rectangle of a specific region, or <code>null</code> if that region 
         *  has no frame. */
        public function getFrame(name:String):Rectangle
        {
            return mTextureFrames[name];
        }
        
        /** Adds a named region for a subtexture (described by rectangle with coordinates in 
         *  pixels) with an optional frame. */
        public function addRegion(name:String, region:Rectangle, frame:Rectangle=null):void
        {
            mTextureRegions[name] = region;
            mTextureFrames[name]  = frame;
        }
        
        /** Removes a region with a certain name. */
        public function removeRegion(name:String):void
        {
            delete mTextureRegions[name];
            delete mTextureFrames[name];
        }
    }
}