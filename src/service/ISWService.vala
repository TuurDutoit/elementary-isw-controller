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

    public class ISWService {
        public static SoundboardService soundboard = new SoundboardService ();
        public static MediaService media = new MediaService ();
        private static Soup.Session session;

        private static Soup.Session get_session () {
            if (session == null) {
                lock (session) {
                    if (session == null) {
                        session = create_session ();
                    }
                }
            }

            return session;
        }

        private static Soup.Session create_session () {
            var session = new Soup.Session ();
            session.ssl_strict = false;

            return session;
        }

        public static void request_method (string method, string uri, Soup.SessionCallback? cb) {
            var msg = new Soup.Message (method, uri);
            get_session ().queue_message (msg, cb);
        }

        public static void request (string uri, Soup.SessionCallback? cb) {
            request_method ("GET", uri, cb);
        }

    }

}