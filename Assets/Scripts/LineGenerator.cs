using UnityEngine;
using System.Collections;

public class LineGenerator : MonoBehaviour {

    public int numLines = 100;
    public int lineResolution = 100;
    public float scale;
    public GameObject prefab;


	// Use this for initialization
	void Start () {
        if(prefab != null)
        {
            for (int i = 0; i < numLines; i++)
            {
                GameObject obj = Instantiate(prefab);
                LineRenderer lineRend = obj.GetComponent<LineRenderer>();
                if(lineRend != null)
                {
                    Vector3 endPosition;
                    Vector3 startPosition = Vector3.zero;
                    endPosition = Random.onUnitSphere;
                    for(int j = 0; j < lineResolution; j++)
                    {
                        float x = Mathf.Lerp(startPosition.x, endPosition.x, (float)j / lineResolution);
                        float y = Mathf.Lerp(startPosition.y, endPosition.y, (float)j / lineResolution);
                        float z = Mathf.Lerp(startPosition.z, endPosition.z, (float)j / lineResolution);
                        lineRend.SetPosition(j, new Vector3(x, y, z) * scale);
                    }
                }
            }
        }

    }
	
	// Update is called once per frame
	void Update () {

	}
}
