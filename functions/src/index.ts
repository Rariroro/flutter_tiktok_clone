import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss",
      "00:00:01.000",
      "-vframes",
      "1",
      "-vf",
      "scale=150:-1",
      `/tmp/${snapshot.id}.jpg`,
    ]);

    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });

    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });
    const db = admin.firestore();
    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({
        thumbnailUrl: file.publicUrl(),
        videoId: snapshot.id,
      });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likedId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();

    const [videoId, userId] = snapshot.id.split("000");
    const thumbnailUrl = (
      await db.collection("videos").doc(videoId).get()
    ).data()!.thumbnailUrl;
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(1) });
    await db
      .collection("users")
      .doc(userId)
      .collection("likes")
      .doc(videoId)
      .set({ thumbnailUrl: thumbnailUrl as String, videoId: videoId });

    const video = (await db.collection("videos").doc(videoId).get()).data();
    if (video) {
      const creatorUid = video.creatorUid;
      const user = await (
        await db.collection("users").doc(creatorUid).get()
      ).data();
      if (user) {
        const token = user.token;
        await admin.messaging().send({
          token,
          data: { screen: "123" },
          notification: {
            title: "someone liked your video.",
            body: "Likes + 1! Congrats!",
          },
        });
      }
    }
  });

export const onLikedRemoed = functions.firestore
  .document("likes/{likedId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(-1) });
    await db
      .collection("users")
      .doc(userId)
      .collection("likes")
      .doc(videoId)
      .delete();
  });

// export const onChatCreated = functions.firestore
// .document("chat_rooms/{chatId}")
// .onCreate(async (snapshot, context) => {
//   const db = admin.firestore();

//   const personA = (await db.collection("chat_rooms").doc(snapshot.id).get()).data()!.personA;
//   const personB=(await db.collection("chat_rooms").doc(snapshot.id).get()).data()!.personB;

//   await db.collection("chat_rooms").doc(snapshot.id).set({id:snapshot.id,},{merge:true});

//   await db
//     .collection("users")
//     .doc(personA)
//     .collection("chat_rooms")
//     .doc(snapshot.id)
//     .set({personA:personA as String, personB: personB,chatId:snapshot.id });
//     await db
//     .collection("users")
//     .doc(personB)
//     .collection("chat_rooms")
//     .doc(snapshot.id)
//     .set({personA:personA as String, personB: personB ,chatId:snapshot.id});
// });
