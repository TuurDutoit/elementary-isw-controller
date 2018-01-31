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

namespace isw.controller.service {

    errordomain MyErrors {
        TOO_MANY_DIRS
    }

    public class SoundboardService {
        private static int _i = 0;
        private const string BASE_URL = "https://m.isw/api/sb/";
        private Directory root;

        public SoundboardService () {
            update_sounds ();
        }

        public Directory get_sounds () {
            return root;
        }

        public void update_sounds () {
            ISWService.request(BASE_URL, (session, message) => {
                var str = (string) message.response_body.data;
                print ("JSON: %s\n\n\n\n\n", str);

                try {
                    var parser = new Json.Parser ();
                    parser.load_from_data (str);
                    var node = parser.get_root ();
                    print ("root type: %s\n", node.type_name ());
                    var list = node.get_array ();
                    root = Directory.from_json (list);
                    sounds_updated (root);
                }
                catch (Error e) {
                    stdout.printf ("Error parsing JSON: %s", e.message);
                }
            });
        }

        public signal void sounds_updated (Directory sounds);

        public class Directory {
            private Gee.Map<string, Directory> subdir_map;
            public List<Directory> dirs;
            public List<Sound> sounds;
            public string name;
            private string path;

            private Directory (string path) {
                this.subdir_map = new Gee.HashMap<string, Directory> ();
                this.dirs = new List<Directory> ();
                this.sounds = new List<Sound> ();
                this.path = path;
                this.name = path.substring (path.last_index_of ("/") + 1);
            }

            public static Directory from_json (Json.Array list) {
                var root = new Directory ("");
                
                print("Populating content\n");
                print("==================\n");
                for (var i = 0, len = list.get_length (); i < len; i++) {
                    var obj = list.get_object_element (i);
                    var sound = Sound.from_json (obj);
                    root.add (sound);
                }

                print("Sorting contents\n");
                print("================\n");
                root.sort ();

                return root;
            }

            public string get_name () {
                return name;
            }

            private void add (Sound sound) {
                // Protect against infinite loops
                _i++;
                if(_i > 100000) {
                    throw new MyErrors.TOO_MANY_DIRS ("Too many dirs");
                }
                
                if (sound.dirname == this.path) {
                    //print ("  Add to this dir\n");
                    this.sounds.append (sound);
                }
                else {
                    var index = sound.dirname.index_of ("/");
                    var dirname = index == -1 ? sound.dirname : sound.dirname.splice (0, index);
                    //print ("  subdir: %s\n", dirname);

                    if (!subdir_map.has_key (dirname)) {
                        var new_path = this.path.length == 0 ? dirname : this.path + "/" + dirname;
                        var new_dir = new Directory (new_path);
                        subdir_map.set (dirname, new_dir);
                        dirs.append (new_dir);
                    }

                    var dir = subdir_map.get (dirname);
                    dir.add (sound);
                }
            }

            private void sort () {
                this.sounds.sort ((a, b) => {
                    if (a.name < b.name) {
                        return -1;
                    }
                    else if (a.name > b.name) {
                        return 1;
                    }

                    return 0;
                });

                this.dirs.sort ((a, b) => {
                    if (a.name < b.name) {
                        return -1;
                    }
                    else if (a.name > b.name) {
                        return 1;
                    }

                    return 0;
                });

                foreach (var dir in this.dirs) {
                    dir.sort ();
                }
            }

        }

        public class Sound {
            public string name;
            public string path;
            public string url;
            public string dirname;

            public Sound (string path) {
                var index = path.last_index_of_char ('/');
                this.name = path.substring (index + 1);
                this.path = path;
                this.url = BASE_URL + path;
                this.dirname = index == -1 ? "" : path.slice (0, index);
            }

            public static Sound from_json (Json.Object obj) {
                var urlSnip = obj.get_string_member ("urlSnip");
                return new Sound (urlSnip);
            }

            public void play () {
                ISWService.request (this.url, null);
            }
        }
    }

}