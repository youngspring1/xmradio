import cookielib
import urllib2
import logging
import atexit

cookie_store = "cookies.txt"

logger = logging.getLogger('init')


def init():
    logging.basicConfig(level=logging.DEBUG)

    cj = cookielib.MozillaCookieJar(cookie_store)
    try:
        cj.load()
        logger.info('cookies loaded')
    except:
        logger.info('no cookies present')

    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    opener.addheaders = (
        ('User-agent',
         'Mozilla/5.0 (X11; Linux x86_64; rv:46.0.1) Gecko/20100101 Firefox/46.0.1'),)
    urllib2.install_opener(opener)

    state = {'cookiejar': cj}
    atexit.register(save_cookies, state)
    return state


def save_cookies(state):
    state['cookiejar'].save()
    logging.info('cookies saved')
