/*
 * Copyright (C), 2007, Mathieu Kooiman < xdc@scriptorama.nl> 
 * $Id: IFileLoader.cs 19 2007-04-30 07:44:15Z mathieuk $
 * 
 * This file is part of XDebugClient.
 *
 *  XDebugClient is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2.1 of the License, or
 *  (at your option) any later version.

 *  XDebugClient is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with XDebugClient; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

using System;
using System.Collections.Generic;
using System.Text;

namespace xdc.GUI.FileLoader
{
    
    abstract class FileLoader
    {
        protected XDebug.Client _client;

        public abstract bool AllowsOpenFileDialog
        {
            get;
        }

        public void setClient(XDebug.Client client)
        {
            _client = client;
        }
            
        public abstract bool OpenFile(xdc.Forms.SourceFileForm targetForm, string filename);
        public abstract bool DetermineLocalFilename(string filename, ref string localFilename);
        public abstract bool DetermineRemoteFilename(string localFilename, ref string tmpRemoteFilename);        
    }

}
