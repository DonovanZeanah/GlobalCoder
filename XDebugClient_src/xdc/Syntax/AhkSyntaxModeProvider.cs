using System;
using System.Collections.Generic;
using System.Text;
using ICSharpCode.TextEditor;
using ICSharpCode.TextEditor.Document;
using System.IO;
using System.Xml;

namespace xdc.Syntax
{
    public class AhkSyntaxModeProvider : ISyntaxModeFileProvider
    {
        List<SyntaxMode> syntaxModes;

        public AhkSyntaxModeProvider()
        {
            Stream stream = typeof(AhkSyntaxModeProvider).Assembly.GetManifestResourceStream("xdc.Syntax.SyntaxModes.xml");
            if (stream != null)
                syntaxModes = SyntaxMode.GetSyntaxModes(stream);
            else
                syntaxModes = new List<SyntaxMode>();
        }

        public XmlTextReader GetSyntaxModeFile(SyntaxMode syntaxMode)
        {
            return new XmlTextReader(typeof(AhkSyntaxModeProvider).Assembly.GetManifestResourceStream("xdc.Syntax." + syntaxMode.FileName));
        }

        public ICollection<SyntaxMode> SyntaxModes
        {
            get { return syntaxModes; }
        }

        public void UpdateSyntaxModeList()
        {
        }
    }
}
