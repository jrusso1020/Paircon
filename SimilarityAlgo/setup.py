import os
from setuptools import setup, find_packages, Command
from setuptools.command.install import install as _install

# Thanks http://stackoverflow.com/questions/3779915/why-does-python-setup-py-sdist-create-unwanted-project-egg-info-in-project-r
class CleanCommand(Command):
    """Custom clean command to tidy up the project root."""
    user_options = []
    def initialize_options(self):
        pass
    def finalize_options(self):
        pass
    def run(self):
        os.system('rm -vrf ./build ./dist ./*.pyc ./*.tgz ./*.egg-info')

class Install(_install):
    def run(self):
        _install.do_egg_install(self)
        import nltk
        nltk.download("punkt")

requirements = [
                'nltk',
                'scikit-learn',
                'numpy',
                'scipy',
                'flask',
                'flask-cors',
                'gunicorn'
                ]




setup(
    name="similiarity_algo",
    description="similiarity algorithm for XXX",
    version=1.0,
    packages=find_packages(),
    install_requires=requirements,
    setup_requires=['nltk'],
    include_package_data=True,
    # test_suite='nose2.collector.collector',
    # tests_require=['nose2','httmock','mock'],
    cmdclass={
          'clean': CleanCommand,
          'install': Install
      }
)