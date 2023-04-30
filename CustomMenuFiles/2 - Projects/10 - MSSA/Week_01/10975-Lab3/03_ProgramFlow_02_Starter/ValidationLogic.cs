using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _03_ProgramFlow_02_Solution
{
    public class ValidationLogic
    {
        public const int COURSE_MAX_LENGTH = 50;
        public const int COURSE_MIN_LENGTH = 5;

        public static bool ValidateCourseTitle(string courseTitle)
        {
            return courseTitle.Length >= COURSE_MIN_LENGTH
                    && courseTitle.Length <= COURSE_MAX_LENGTH;
        }
    }
}
