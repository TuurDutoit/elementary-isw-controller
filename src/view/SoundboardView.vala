/*
* Copyright (c) 2018 Tuur Dutoit (https://tuurdutoit.be)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

using Granite.Widgets;

using isw.controller.service;

namespace isw.controller.view {

    public class SoundboardView : Gtk.Stack {
        private SoundboardService service;
        private SourceList list;
        private Gtk.Box content;

        public SoundboardView () {
            build ();

            service = new SoundboardService ();
            service.sounds_updated.connect (populate_sounds);
        }

        private void build () {
            var spinner = new Gtk.Spinner ();
            spinner.active = true;
            spinner.halign = Gtk.Align.CENTER;
            spinner.vexpand = true;

            list = new SourceList ();
            list.ellipsize_mode = Pango.EllipsizeMode.NONE;
            //list.propagate_natural_width = true;

            content = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);

            var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            pane.pack1 (list, false, false);
            pane.pack2 (content, true, false);

            add_named (spinner, "loading");
            add_named (pane, "view");
        }

        private void populate_sounds (SoundboardService.Directory dir) {
            list.root.clear ();
            populate_sounds_in (dir, list.root);
            set_visible_child_name ("view");
        }

        private void populate_sounds_in (SoundboardService.Directory dir, SourceList.ExpandableItem root) {
            foreach (var d in dir.dirs) {
                if (d.dirs.length () != 0) {
                    var sub = new SourceList.ExpandableItem (d.name);
                    populate_sounds_in (d, sub);
                    root.add (sub);
                }
                else {
                    root.add (new SourceList.Item (d.name));
                }
            }
        }

    }

}