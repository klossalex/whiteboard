import cherrypy
import urllib2

CAS_CHECK_PATH = '/Auth/CASLogin'

def auth_handler(cas_server_root):

    def redirect_to_cas():
        raise cherrypy.HTTPRedirect(cas_server_root + 'login?service=%s' % cherrypy.url(CAS_CHECK_PATH))

    def get_cas_username(ticket):
        cas_check_url = cas_server_root + 'validate?ticket=%s&service=%s' % (ticket, cherrypy.url(CAS_CHECK_PATH))
        cas_response = urllib2.urlopen(cas_check_url).read()
        if cas_response[0:3] == "yes":
            return cas_response[4:].strip()
        else:
            return None

    # Actual CAS authentication logic
    if cherrypy.request.path_info == CAS_CHECK_PATH:
        if 'ticket' in cherrypy.request.params:
            ticket = cherrypy.request.params['ticket']
            username = get_cas_username(ticket)
            if username is not None:
                cherrypy.session['username'] = username
                raise cherrypy.HTTPRedirect('/')

    if not 'username' in cherrypy.session:
        redirect_to_cas()

cherrypy.tools.cas_auth = cherrypy.Tool('before_handler', auth_handler)