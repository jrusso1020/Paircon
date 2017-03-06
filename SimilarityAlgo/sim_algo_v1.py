import nltk, string
import glob
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
import numpy as np

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

  def compute_cosine_sim(self, user_dir, conference_dir, k):
    """
    compute the conside similiarity between two documents after being tokenized
    PARAMS: user_dir = the absolute path to a directory containing the text versions of all a users documents
            conference_dir = the absolute path to a directory contaiing the text versoins of all a conference documents
            k = number of similiar documents to return
    RETURNS: a value which is the cosine similiarity of two academic papers
    """
    # save all text into documents
    user_docs = glob.glob(user_dir + "/*.txt")
    user_papers = []
    for doc in user_docs:
      with open(doc, 'r') as my_file:
        user_papers.append(my_file.read())

    conference_docs = glob.glob(conference_dir + "/*.txt")
    conference_papers = []
    for doc in conference_docs:
      with open(doc, 'r') as my_file:
        conference_papers.append(my_file.read())

    # change to numpy arrays for list indexing
    both_papers = np.array(user_papers + conference_papers)
    user_docs = np.array(user_docs)
    user_papers = np.array(user_papers)
    conference_docs = np.array(conference_docs)
    conference_papers = np.array(conference_papers)

    # create tf idf vectors for user papers and conference papers
    tf_idf = self.tfidf_vectorizer.fit_transform(both_papers)

    # compute consine similiarity
    cosine_sim = linear_kernel(tf_idf[0:len(user_papers)], tf_idf[len(user_papers):])

    # get the indices and scores for the most similiar user paper to each conference paper
    indices_top_docs = np.argsort(cosine_sim, axis=0)[:-2:-1].flatten()
    scores_top_docs = np.sort(cosine_sim, axis=0)[:-2:-1].flatten()

    # get the top k indices from the most similiar papers and only use those
    top_k = np.argsort(scores_top_docs)[:-(k+1):-1]

    # get the file names for the top k user and conference papers
    top_k_users = user_docs[indices_top_docs[top_k]]
    top_k_papers = conference_docs[top_k]

    results = {}
    for idx in range(k):
      results[str(idx+1)] = {'user_paper': top_k_users[idx],
                      'conference_paper': top_k_papers[idx],
                      'score': scores_top_docs[top_k[idx]]}

    return results


    
