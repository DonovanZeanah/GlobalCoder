using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SampleMvcApplication.Models;

namespace SampleMvcApplication.Controllers
{
    public class PlaceholderController : Controller
    {
        private ApplicationDbContext _context;

        public PlaceholderController()
        {
            _context = new ApplicationDbContext();
        }

        protected override void Dispose(bool disposing)
        {
            _context.Dispose();
        }

        // GET: /Placeholder/
        public ActionResult Index()
        {
            var placeholders = _context.Placeholders.ToList();
            return View(placeholders);
        }

        // GET: /Placeholder/Details/5
        public ActionResult Details(int id)
        {
            var placeholder = _context.Placeholders.SingleOrDefault(p => p.Id == id);
            if (placeholder == null)
                return HttpNotFound();
            return View(placeholder);
        }

        // GET: /Placeholder/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: /Placeholder/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Placeholder placeholder)
        {
            if (!ModelState.IsValid)
                return View(placeholder);

            _context.Placeholders.Add(placeholder);
            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        // GET: /Placeholder/Edit/5
        public ActionResult Edit(int id)
        {
            var placeholder = _context.Placeholders.SingleOrDefault(p => p.Id == id);
            if (placeholder == null)
                return HttpNotFound();
            return View(placeholder);
        }

        // POST: /Placeholder/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Placeholder placeholder)
        {
            if (!ModelState.IsValid)
                return View(placeholder);

            var placeholderInDb = _context.Placeholders.Single(p => p.Id == placeholder.Id);
            placeholderInDb.Name = placeholder.Name;
            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        // GET: /Placeholder/Delete/5
        public ActionResult Delete(int id)
        {
            var placeholder = _context.Placeholders.SingleOrDefault(p => p.Id == id);
            if (placeholder == null)
                return HttpNotFound();
            return View(placeholder);
        }

        // POST: /Placeholder/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(Placeholder placeholder)
        {
            var placeholderInDb = _context.Placeholders.Single(p => p.Id == placeholder.Id);
            _context.Placeholders.Remove(placeholderInDb);
            _context.SaveChanges();

            return RedirectToAction("Index");
        }
    }
}