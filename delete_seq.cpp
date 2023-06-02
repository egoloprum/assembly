#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

extern "C" void printResult(const char* result, int str_len);

constexpr auto max_string_length = 256;
const int min_sequence_length = 3;

vector<string> removeSequence(vector<string> sentence) {
	int flag = 3;
	char tmp = ' ';
	vector<int> buff;
	vector<vector<int>> indexs;
	vector<string> new_sentence;
	int _counter = 0;
	vector<int> _tmp_counter;


	// FIND SEQUENCE INDEXs
	for (string word : sentence) {
		for (auto i = 0; i < word.size(); i++) {
			if (word[i] != tmp) {
				tmp = word[i];
				flag = 3;
			}
			else {
				flag -= 1;
			}

			if (flag <= 1) {
				buff.push_back(i);
			}
		}
		if (buff.size() != 0) {
			_tmp_counter.push_back(_counter);
			indexs.push_back(buff);
		}
		tmp = ' ';
		buff.clear();
		_counter += 1;
	}


	// DELETE SEQUENCES BY INDEX
	_counter = 0;
	string word = "";
	for (auto i = 0; i < sentence.size(); i++) {
		if (find(_tmp_counter.begin(), _tmp_counter.end(), i) != _tmp_counter.end()) {
			word = sentence[i];

			for (int z = indexs[_counter].size() - 1; z >= 0; z--) {
				word.erase(word.begin() + indexs[_counter][z]);

				if (z == 0) {
					for (int x = 1; x < min_sequence_length; x++) {
						word.erase(word.begin() + (indexs[_counter][z] - x));
					}
				}
				else {
					if (indexs[_counter][z - 1] != indexs[_counter][z] - 1) {
						for (int x = 1; x < min_sequence_length; x++) {
							word.erase(word.begin() + (indexs[_counter][z] - x));
						}
					}
				}
			}
			_counter += 1;
		}
		else {
			word = sentence[i];
		}
		new_sentence.push_back(word);
	}


	return new_sentence;
}

vector<string> inputValue(){
        string input_stream;
	    vector<string> sentence;
    	for (int i = 0; i < max_string_length; i++) {
            cin >> input_stream;

            if (input_stream == "0") {
                break;
            }

            sentence.push_back(input_stream);
	    }
    return sentence;
}

int main(){
    vector<string> sentence;
    cout << "input words whose length is less than 255" << endl;
    sentence = inputValue();
    vector<string> processed_sentence = removeSequence(sentence);

    cout << endl << "result will be" << endl;

    string word = "";   

    for(int i = 0; i < processed_sentence.size(); i++){
        word += processed_sentence[i] + " ";
    }

    word += "\n\n";

    const char* str = word.c_str();
    int strlen = word.length() - 1;
    printResult(str, strlen);

    //for(string word : processed_sentence){
    //    strlen = word.length() - 1;
    //    const char* str = word.c_str();
    //    printResult(str, strlen);
    //}

    return 0;
}