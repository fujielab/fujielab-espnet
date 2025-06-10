# %%
from pylib.cejc_util import CEJCSpeakerInfo, CEJCTextData
import os
import shutil

def main(outdir, cejc_dir, cejc_orig_dir, cejc_safia_dir):
    cejc_speaker_info = CEJCSpeakerInfo(cejc_dir=cejc_dir, 
                                        cejc_orig_dir=cejc_orig_dir, 
                                        cejc_safia_dir=cejc_safia_dir)
    session_id_list = cejc_speaker_info.get_session_id_list()
    speaker_info = cejc_speaker_info.get_speaker_info_in_session(session_id_list[0])
    spaker_id_list = list(speaker_info["id2label"].keys())


    # %%
    if os.path.exists(outdir):
        shutil.rmtree(outdir)

    # %%
    for session_id in session_id_list:
        print(f"### session_id: {session_id} ###", flush=True)

        speaker_info = cejc_speaker_info.get_speaker_info_in_session(session_id)

        suw_filepath = cejc_speaker_info.get_session_suw_filepath(session_id)
        luw_filepath = cejc_speaker_info.get_session_luw_filepath(session_id)
        speaker_info = cejc_speaker_info.get_speaker_info_in_session(session_id)

        cejc_text_data = CEJCTextData(suw_filepath, luw_filepath, speaker_info)

        for speaker_id in speaker_info["id2label"].keys():
            print(f"session_id: {session_id} speaker_id: {speaker_id}", flush=True)
            if speaker_info["id2wavfilename"][speaker_id] is None:
                # 警告を表示する
                print(f"wav file not found: {speaker_id}")
                continue

            wav_filepath = cejc_speaker_info.get_session_wav_filepath(session_id, speaker_id, mode="safia")
            wav_id = os.path.basename(wav_filepath).split(".")[0]

            texts = []
            segments = []
            utt2spks = []

            for t in cejc_text_data.text_info:
                if t.speaker_id == speaker_id and \
                t.utterance_id != "" and \
                t.utterance_pron != "":
                    utterance_id = t.utterance_id
                    pron = t.utterance_pron
                    start_time = t.start_time
                    end_time = t.end_time
                    # text
                    texts.append(f"{utterance_id} {pron}")
                    # segments
                    segments.append(f"{utterance_id} {wav_id} {start_time} {end_time}")
                    # utts
                    utt2spks.append(f"{utterance_id} {speaker_id}")

            if len(texts) == 0:
                # 警告を表示する
                print(f"text not found: {speaker_id} at {session_id}")
                continue

            indiv_dir = f"{outdir}/{speaker_id}"
            os.makedirs(indiv_dir, exist_ok=True)
            with open(f"{indiv_dir}/text", "a") as f:
                f.write("\n".join(texts) + "\n")
            with open(f"{indiv_dir}/segments", "a") as f:
                f.write("\n".join(segments) + "\n")
            with open(f"{indiv_dir}/utt2spk", "a") as f:
                f.write("\n".join(utt2spks) + "\n")
            with open(f"{indiv_dir}/wav.scp", "a") as f:
                f.write(f"{wav_id} {wav_filepath}\n")

if __name__ == "__main__":
    # コマンドライン引数を読み込む
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--outdir", type=str, default="data/indiv")
    parser.add_argument("--cejc_dir", type=str, default="/autofs/diamond2/share/corpus/CEJC2304")
    parser.add_argument("--cejc_orig_dir", type=str, default="/autofs/diamond2/share/corpus/CEJC")
    parser.add_argument("--cejc_safia_dir", type=str, default="/autofs/diamond2/share/corpus/CEJC_safia")
    args = parser.parse_args()
    main(args.outdir, args.cejc_dir, args.cejc_orig_dir, args.cejc_safia_dir)
