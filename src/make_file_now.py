import logging
import os
import shutil
from argparse import ArgumentParser

logger = logging.getLogger('mfn')
logger.setLevel(logging.INFO)

FEATURE_GENERATE_MAKEFILE = True
FEATURE_PROJECT_INIT = True

HOME_DIR = os.getenv('HOME')
PWD_DIR = os.getenv('PWD')
LOG_CONFIG_PATH = '{}/mfn.log'.format(HOME_DIR)

logging.basicConfig(filename=LOG_CONFIG_PATH)
logger_stdout = logging.StreamHandler()
logger_stdout.setFormatter(logging.Formatter(logging.BASIC_FORMAT))
logging.getLogger().addHandler(logger_stdout)

project_language = 'todo' # todo

if (os.getenv('VERBOSE', False)):
    logger.setLevel(logging.DEBUG)


# more than just mfn
def init_project_py():
    source_requirements = os.path.join(os.getcwd(), 'src/tpl/requirements.txt')
    target_requirements = os.path.join(PWD_DIR, 'requirements.txt')

    shutil.copy2(source_requirements, target_requirements)


def has_existing_makefile(working_dir=os.path.join(PWD_DIR)):
    return os.path.isfile(os.path.join(working_dir, 'Makefile'))


def generate_makefile(project):
    if (FEATURE_GENERATE_MAKEFILE):
        source_makefile = os.path.join(os.getcwd(), 'src/tpl/Makefile.default.tpl')

        source_makefile_alt = os.path.join(os.getcwd(), 'src/tpl/Makefile.{}.tpl'.format(project))
        if (os.path.isfile(source_makefile_alt)):
            source_makefile = source_makefile_alt

        logging.debug('makefile={} alt={}'.format(source_makefile, source_makefile_alt))

        target_makefile = PWD_DIR ## working dir?
        shutil.copy2(source_makefile, os.path.join(PWD_DIR, 'Makefile'))

    if (FEATURE_PROJECT_INIT):
        if (project == 'py'):
            init_project_py()


def parse_arguments(args=None):
    parser = ArgumentParser()
    parser.add_argument('--project', default='defailt', help="project makefile")
    parser.add_argument('--force', help="overwrite existing", action='store_true')
    return parser.parse_args(args)

def main():
    args = parse_arguments()
    if (has_existing_makefile() and args.force):
        logger.debug('has makefile in cwd={}'.format(os.getcwd()))
        print('Makefile detected')
        print('use --force [-f] if required')
    else:
        logger.debug('needs makefile')
        generate_makefile(args.project)


if __name__ == '__main__':
    main()
