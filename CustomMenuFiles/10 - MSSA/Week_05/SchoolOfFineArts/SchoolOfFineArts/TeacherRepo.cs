using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using SchoolOfFineArtsDB;
using SchoolOfFineArtsModels;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SchoolOfFineArts
{
    public class TeacherRepo
    {
        private DbContextOptionsBuilder _optionsBuilder;

        public TeacherRepo(DbContextOptionsBuilder optionsBuilder)
        {
            _optionsBuilder = optionsBuilder;
        }

        public List<Teacher> GetAll()
        {
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                return context.Teachers.ToList();
            }
        }

        public void Delete(Teacher t)
        {
            using (var context = new SchoolOfFineArtsDBContext(_optionsBuilder.Options))
            {
                context.Teachers.Remove(t);
                context.SaveChanges();
            }
        }

    }
}
