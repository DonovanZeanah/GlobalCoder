using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SampleNamespace.Models;

namespace SampleNamespace.Controllers
{
    public class PlaceholderController : Controller
    {
        private ApplicationDbContext _context;

        public PlaceholderController()
        {
            _context = new ApplicationDbContext();
        }

        // GET: Placeholder
        public ActionResult Index()
        {
            var placeholderItems = _context.PlaceholderItems.ToList();
            return View(placeholderItems);
        }

        // GET: Placeholder/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Placeholder/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(PlaceholderItem placeholderItem)
        {
            if (ModelState.IsValid)
            {
                _context.PlaceholderItems.Add(placeholderItem);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(placeholderItem);
        }

        // GET: Placeholder/Edit/5
        public ActionResult Edit(int id)
        {
            var placeholderItem = _context.PlaceholderItems.SingleOrDefault(p => p.Id == id);

            if (placeholderItem == null)
                return HttpNotFound();

            return View(placeholderItem);
        }

        // POST: Placeholder/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, PlaceholderItem placeholderItem)
        {
            if (ModelState.IsValid)
            {
                var itemInDb = _context.PlaceholderItems.Single(p => p.Id == id);
                itemInDb.Name = placeholderItem.Name;
                itemInDb.Description = placeholderItem.Description;

                _context.SaveChanges();

                return RedirectToAction("Index");
            }

            return View(placeholderItem);
        }

        // GET: Placeholder/Delete/5
        public ActionResult Delete(int id)
        {
            var placeholderItem = _context.PlaceholderItems.SingleOrDefault(p => p.Id == id);

            if (placeholderItem == null)
                return HttpNotFound();

            return View(placeholderItem);
        }

        // POST: Placeholder/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var placeholderItem = _context.PlaceholderItems.SingleOrDefault(p => p.Id == id);

            if (placeholderItem == null)
                return HttpNotFound();

            _context.PlaceholderItems.Remove(placeholderItem);
            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                _context.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
