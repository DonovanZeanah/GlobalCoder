using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MinifiedCodeExample
{
    public interface IRemote : ICommonPrint
    {
        string PowerOn();
        string PowerOff();
        string ChangeVolume(int value);
        string ChangeChannel(int value);
    }
}
