import nltk, string
from sklearn.feature_extraction.text import TfidfVectorizer

class Cosine_Similiarity:
  """
  Class for finding the cosine similiarity between two documents
  """
  def __init__(self):
    self.stemmer = nltk.stem.porter.PorterStemmer()
    self.tfidf_vectorizer = TfidfVectorizer(tokenizer=self.tokenizer, stop_words='english')
    self.punctuation_dict = dict((ord(char), None) for char in string.punctuation) # dictionary of punctuation to remove

  def stem_tokens(self, tokens):
    """
    keep the root of words and removing extraneous suffixes
    PARAMS: tokens = a list of tokens
    RETURNS: a list of stemmed tokens
    """
    return [self.stemmer.stem(token) for token in tokens]

  def tokenizer(self, text):
    """
    remove punctuation, stem, lowercase, and tokenize a body of text
    PARAMS: text = a string of text
    RETURNS: a list of tokenized tokens
    """
    return self.stem_tokens(nltk.word_tokenize(text.lower().translate(self.punctuation_dict)))

  def compute_cosine_sim(self, paper_body1, paper_body2):
    """
    compute the conside similiarity between two documents after being tokenized
    PARAMS: paper_body1 = the body of text for a user's academic paper
            paper_body2 = the body of text for a conference's academic paper
    RETURNS: a value which is the cosine similiarity of two academic papers
    """
    tf_idf = self.tfidf_vectorizer.fit_transform([paper_body1, paper_body2])
    return ((tf_idf * tf_idf.T).A)[0,1]
