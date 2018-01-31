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
*/

using isw.controller.view;

namespace isw.controller {

    public class MainWindow : Gtk.ApplicationWindow {

        public MainWindow (Gtk.Application application) {
            Object (
                application: application,
                icon_name: "com.github.tuurdutoit.elementary-isw-controller",
                title: _("ISW Controller"),
                resizable: false,
                height_request: 700
            );
        }

        construct {
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            set_keep_below (true);
            stick ();
            //use_header_bar = 1;

            var stack = new Gtk.Stack ();
            stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            stack.vhomogeneous = true;
            stack.add_titled (new MediaView (), "now-playing", _("Now Playing"));
            stack.add_titled (new Gtk.Spinner (), "playlist", _("Playlist"));
            stack.add_titled (new SoundboardView (), "soundboard", _("Soundboard"));
            stack.add_titled (new Gtk.Spinner (), "aircon", _("Airconditioner"));
            stack.add_titled (new Gtk.Spinner (), "shop", _("Shop"));

            var switcher = new Gtk.StackSwitcher ();
            switcher.set_halign (Gtk.Align.CENTER);
            switcher.set_stack (stack);

            this.add (stack);

            //  var content_box = get_content_area () as Gtk.Box;
            //  content_box.border_width = 0;
            //  content_box.add (stack);
            //  content_box.show_all ();

            //  var action_box = get_action_area () as Gtk.Box;
            //  action_box.visible = false;

            var headerbar = new Gtk.HeaderBar ();
            headerbar.show_close_button = true;
            headerbar.set_title (_("ISW Controller"));
            headerbar.set_custom_title (switcher);
            headerbar.show_all ();
            set_titlebar (headerbar);

            button_press_event.connect ((e) => {
                if (e.button == Gdk.BUTTON_PRIMARY) {
                    begin_move_drag ((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
                    return true;
                }
                return false;
            });
        }
    }

}