#region usings
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;

using VVVV.PluginInterfaces.V1;
using VVVV.PluginInterfaces.V2;
using VVVV.Utils.VColor;
using VVVV.Utils.VMath;

using VVVV.Core.Logging;
#endregion usings

namespace VVVV.Nodes
{
	#region PluginInfo
	[PluginInfo(Name = "Stringify3", Category = "Enumerations", Version = "Static", Help = "Basic template with native .NET enum type", Tags = "")]
	#endregion PluginInfo
	public class StaticEnumerationsStringify3Node : IPluginEvaluate
	{
		#region fields & pins
		[Input("Input", EnumName = "AllEnums")]
		public IDiffSpread<EnumEntry> FInput;
		
		[Output("Name")]
		public ISpread<string> FNameOutput;
		
		[Output("Entries")]
		public ISpread<ISpread<string>> FEntryOutput;
		
		[Import()]
		public ILogger Flogger;
		#endregion fields & pins
		
		//called when data for any output pin is requested
		public void Evaluate(int SpreadMax)
		{
			FNameOutput.SliceCount = SpreadMax;
			FEntryOutput.SliceCount = SpreadMax;
			
			if (FInput.IsChanged)
			{
				for (int i=0; i<SpreadMax; i++)
				{
					var enumname = FInput[i].Name;
					FNameOutput[i] = enumname;
					
					var entries = new List<string>();
					
					int enumcount = EnumManager.GetEnumEntryCount(enumname); //gets the enumentrycount. used to iterate through the entry indices
					
					for (int j = 0; j < enumcount; j++)
						entries.Add(EnumManager.GetEnumEntry(enumname, j));
					
					FEntryOutput[i].AssignFrom(entries);
				}
			}
		}
	}
}
