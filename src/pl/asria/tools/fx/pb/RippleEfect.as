package pl.asria.tools.fx.pb 
{
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.events.TimerEvent;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author trzeci.eu
	 */
	public class RippleEfect 
	{
		[Embed(source = '../pbk/ripple.pbj', mimeType = 'application/octet-stream')]
		private static var rippleDataClass :Class;
		private static var rippleData :ByteArray;
		
		{
			rippleData = new rippleDataClass() as ByteArray;
		}
		
		public function RippleEfect() 
		{
			new Shader();
		}
		
		private static const _coleration:Dictionary = new Dictionary(true);
		public static function adoptAnimation(target:DisplayObject, point:Point, size:Number, amount:Number, time:Number, fps:Number, onComplete:Function):void
		{
			if (!target) return;
			var shader:Shader = new Shader(rippleData);
			var shaderFilter:ShaderFilter = new ShaderFilter(shader);
			
			shader.data.size.value = [size];
			shader.data.phase.value = [0];
			shader.data.amount.value = [amount];
			shader.data.radius.value = [50];
			shader.data.center.value = [point.x, point.y];
			
			//var filters:Array = [shaderFilter];
			//filters = filters.concat(target.filters);
			//target.filters = filters;
			target.filters = [shaderFilter];
			
			var timer:Timer = new Timer(1000/fps);
			timer.addEventListener(TimerEvent.TIMER, updateShaderHandler);
			_coleration[timer] = new PBShaderAbimData(shader, shaderFilter, target, amount/(time * 1000 / fps), onComplete);
			timer.start();
		}
		
		static private function updateShaderHandler(e:TimerEvent):void 
		{
			var data:PBShaderAbimData = _coleration[e.currentTarget];
			
			data.shader.data.phase.value[0] += 0.6;
			data.shader.data.size.value[0] *= 0.995;
			data.shader.data.radius.value[0] += 6;
			data.shader.data.amount.value[0] -= data.amountOffset;
			
			data.target.filters = data.target.filters;
			if (data.shader.data.amount.value[0] < 0)
			{
				//data.target.filters.splice(data.target.filters.indexOf(data.shaderFilter), 1, 0);
				//data.target.filters = data.target.filters;
				data.target.filters = [];
				e.currentTarget.stop();
				e.currentTarget.removeEventListener(TimerEvent.TIMER, updateShaderHandler);
				if (data.onComplete != null) data.onComplete();
				data.clean();
			}
			
			
		}
	}

}
import flash.display.DisplayObject;
import flash.display.Shader;
import flash.filters.ShaderFilter;

internal final class PBShaderAbimData
{
	public var shaderFilter:ShaderFilter;
	public var onComplete:Function;
	public var shader:Shader;
	public var target:DisplayObject;
	public var amountOffset:Number;
	public function PBShaderAbimData(shader:Shader, shaderFilter:ShaderFilter, target:DisplayObject, amountOffset:Number, onComplete:Function):void
	{
		this.shaderFilter = shaderFilter;
		this.onComplete = onComplete;
		this.amountOffset = amountOffset;
		this.target = target;
		this.shader = shader;
		
	}
	
	public function clean():void 
	{
		return;
		target = null;
		onComplete = null;
		shaderFilter = null;
	}
}