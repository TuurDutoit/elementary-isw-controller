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

using isw.controller.service;

namespace isw.controller.view {

    public class MediaView : Gtk.Stack {
        private Gtk.Label view;

        public MediaView () {
            var spinner = new Gtk.Spinner ();
            spinner.active = true;
            spinner.halign = Gtk.Align.CENTER;
            spinner.vexpand = true;

            view = new Gtk.Label (null);

            this.transition_type = Gtk.StackTransitionType.NONE;
            this.vhomogeneous = true;
            this.add_named (spinner, "loading");
            this.add_named (view, "view");

            
        }

    }

}