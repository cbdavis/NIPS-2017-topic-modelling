# NIPS-2017-topic-modelling
[Topic modelling](https://en.wikipedia.org/wiki/Topic_model) of all [posters & presentations at NIPS 2017](https://nips.cc/Conferences/2017/Schedule).  See **[Online Visualization](https://cbdavis.github.io/NIPS-2017-topic-modelling/topic-modelling-visualization/index.html#)**. The text analyzed includes the title, abstract, and full-text pdf (where available).

Details about how to navigate the topic modelling results can be found on the [dfr-browser](http://agoldst.github.io/dfr-browser/) project page.

## Screenshots

View all the topics:
<a href="https://cbdavis.github.io/NIPS-2017-topic-modelling/topic-modelling-visualization/index.html#" target="_blank"><img src="https://github.com/cbdavis/NIPS-2017-topic-modelling/raw/master/images/TopicCircles.png"></a>

View all papers within a specific topic:
<img src="https://github.com/cbdavis/NIPS-2017-topic-modelling/raw/master/images/Topic17.png">

View all topics where the word *"gaussian"* is prominent:
<img src="https://github.com/cbdavis/NIPS-2017-topic-modelling/raw/master/images/GaussianTopics.png">

View a single paper, with a link to the original online version:
<img src="https://github.com/cbdavis/NIPS-2017-topic-modelling/raw/master/images/SinglePaper.png">

## Known Issues
Some presentations may show up twice.  In these cases, there was likely both an oral presentation and a poster presentation on the same material.

## Software

The visualization uses the great [dfrtopics R package](https://github.com/agoldst/dfrtopics) by [Andrew Goldstone](https://andrewgoldstone.com/) which in turn uses [MALLET (MAchine Learning for LanguagE Toolkit)](http://mallet.cs.umass.edu/) to perform the actual [Topic Modelling](https://en.wikipedia.org/wiki/Topic_model).
